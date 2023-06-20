//
//  ExchangeRateViewController.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import UIKit

final class ExchangeRateViewController: UIViewController {
    
// MARK: - Properties
    
    private let output = ExchangeRatePresenter()
    
    private let topView = TopView()
    private let loadAnimateView = CircleAnimation()
    private var listCurrencyCollectionView: UICollectionView?
    private var exchangeRate = [CurrentExchangeRate]()
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.input = self
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
                       height: 350)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        listCurrencyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let listCurrencyCollectionView = listCurrencyCollectionView else { return }
        listCurrencyCollectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.identifire)
        listCurrencyCollectionView.delegate = self
        listCurrencyCollectionView.dataSource = self
        listCurrencyCollectionView.layer.cornerRadius = 30
        view.addSubview(listCurrencyCollectionView)
        listCurrencyCollectionView.backgroundColor = .white
        
        listCurrencyCollectionView.anchor(leading: view.leadingAnchor,
                                          top: topView.bottomAnchor,
                                          trailing: view.trailingAnchor,
                                          bottom: view.bottomAnchor,
                                          paddingTop: -15)
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
    
    func showData(_ exchangeRate: [CurrentExchangeRate]) {
        self.exchangeRate = exchangeRate
        listCurrencyCollectionView?.reloadData()
    }
    
    func setTotalAccount(_ total: Double) {
        topView.setTotalAccount(total)
    }
    
    func setCurrency(currency: CurrentExchangeRate, requestCurrency: String) {
        topView.setCurrency(currency, requestCurrency: requestCurrency)
    }
    
    func showAlert(with title: String, and text: String) {
        self.alert(with: title, massage: text)
    }
}

// MARK: - UICollectionVIewDelegate

extension ExchangeRateViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let requestCurrency = exchangeRate[indexPath.row].name
        output.loadCurrency(requestCurrency)
    }
}

// MARK: - UICollectionViewDataSource

extension ExchangeRateViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchangeRate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.identifire,
                                                            for: indexPath) as? CurrencyCell else { return UICollectionViewCell() }
        cell.setInformation(currency: exchangeRate[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ExchangeRateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
}
