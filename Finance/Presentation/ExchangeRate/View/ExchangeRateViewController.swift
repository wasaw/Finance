//
//  ExchangeRateViewController.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import UIKit

private enum Constants {
    static let topViewHeight: CGFloat = 290
    static let listCurrencyCornerRadius: CGFloat = 30
    static let listCurrencyPaddingTop: CGFloat = 15
    static let listCurrencyItemHeight: CGFloat = 90
}

final class ExchangeRateViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: ExchangeRatePresenter
    
    private lazy var topView = TopView()
    private lazy var loadAnimateView = CircleAnimation()
    private var listCurrencyCollectionView: UICollectionView?
    private let listCurrencyAdapter = ListCurrencyAdapter()
    
// MARK: - Lifecycle
    
    init(output: ExchangeRatePresenter) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoadAnimationView()
        configureUI()
        configureCollectionView()
        output.viewIsReady()
    }
    
// MARK: - Helpers
    
    private func configureLoadAnimationView() {
        topView.addSubview(loadAnimateView)
        loadAnimateView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        loadAnimateView.anchor(top: topView.safeAreaLayoutGuide.topAnchor)
        loadAnimateView.configureAnimation()
    }
    
    private func configureUI() {
        view.addSubview(topView)
        topView.anchor(leading: view.leadingAnchor,
                       top: view.topAnchor,
                       trailing: view.trailingAnchor,
                       height: Constants.topViewHeight)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        listCurrencyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let listCurrencyCollectionView = listCurrencyCollectionView else { return }
        listCurrencyCollectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.identifire)
        listCurrencyCollectionView.delegate = self
        listCurrencyCollectionView.dataSource = listCurrencyAdapter
        listCurrencyCollectionView.layer.cornerRadius = Constants.listCurrencyCornerRadius
        view.addSubview(listCurrencyCollectionView)
        listCurrencyCollectionView.backgroundColor = .white
        
        listCurrencyCollectionView.anchor(leading: view.leadingAnchor,
                                          top: topView.bottomAnchor,
                                          trailing: view.trailingAnchor,
                                          bottom: view.bottomAnchor,
                                          paddingTop: -Constants.listCurrencyPaddingTop)
    }
}

// MARK: - ExchangeRateInput

extension ExchangeRateViewController: ExchangeRateInput {
    func setLoading(enable: Bool) {
        if enable {
            loadAnimateView.isHidden = false
        } else {
            loadAnimateView.isHidden = true
        }
    }
    
    func showData(_ exchangeRate: [CurrentExchangeRate], rate: Double) {
        listCurrencyAdapter.configure(exchangeRate, rate: rate)
        listCurrencyCollectionView?.reloadData()
    }

    func setCurrency(currency: CurrentExchangeRate, requestCurrency: String, rate: Double) {
        topView.setCurrency(currency, requestCurrency: requestCurrency, rate: rate)
    }
    
    func showAlert(with title: String, and text: String) {
        self.alert(with: title, message: text)
    }
}

// MARK: - UICollectionVIewDelegate

extension ExchangeRateViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        output.loadCurrency(indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ExchangeRateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width,
                      height: Constants.listCurrencyItemHeight)
    }
}
