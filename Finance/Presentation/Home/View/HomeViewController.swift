//
//  HomeViewController.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2023.
//

import UIKit

private enum Constants {
    static let horizontalPadding: CGFloat = 10
    static let paddingTopTen: CGFloat = 10
    static let paddingTopTwenty: CGFloat = 20
    static let nameLabelHeight: CGFloat = 50
    static let totalAccountHeight: CGFloat = 180
    static let servicesTitleHeight: CGFloat = 20
    static let servicesCollectionHeight: CGFloat = 140
    static let transactionTitleHeight: CGFloat = 20
    static let noTransactionsHeight: CGFloat = 20
    static let lastTransactionsPaddingBottom: CGFloat = 25
    static let sheetPresentationCornerRadius: CGFloat = 26
    static let servicesCollectionItemHeight: CGFloat = 110
    static let servicesCollectionItemWidth: CGFloat = 80
    static let lastTransactionsCollectionItemHeight: CGFloat = 70
    static let minimumLineSpacingForServiceCollection: CGFloat = 25
    static let minimumLineSpacingForLastTransactions: CGFloat = 5
}

final class HomeViewController: UIViewController {
    
// MARK: - Properties
    
    private var output: HomeOutput
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Здравствуйте"
        label.textColor = .totalTintColor
        label.font = UIFont.boldSystemFont(ofSize: 27)
        return label
    }()
    private lazy var totalAccountView = ProgressView()
    private lazy var servicesTitleView = TitleView()
    private lazy var transactionTitleView = TitleView()
    private lazy var noTransactionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Пока нет ни одной записи"
        label.textColor = .totalTintColor
        return label
    }()

    private var servicesCollectionView: UICollectionView?
    private let serviceAdapter = ServiceAdapter()
    private var lastTransactionsCollectionView: UICollectionView?
    private let lastTransactionsAdapter = LastTransactionsAdapter()
    
// MARK: - Lifecycle
    
    init(output: HomeOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        output.viewIsReady()
        view.backgroundColor = .white
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        configurefullNameLabel()
        configureTotalAccountView()
        configureServicesTitleView()
        configureServicesCollectionView()
        configureTransactionTitleView()
        configureLastTransactionsCollectionView()
    }
    
    private func configurefullNameLabel() {
        view.addSubview(fullNameLabel)
        fullNameLabel.anchor(leading: view.leadingAnchor,
                             top: view.safeAreaLayoutGuide.topAnchor,
                             trailing: view.trailingAnchor,
                             paddingLeading: Constants.horizontalPadding,
                             paddingTrailing: -Constants.horizontalPadding,
                             height: Constants.nameLabelHeight)
    }
    
    private func configureTotalAccountView() {
        view.addSubview(totalAccountView)
        totalAccountView.anchor(leading: view.leadingAnchor,
                                top: fullNameLabel.bottomAnchor,
                                trailing: view.trailingAnchor,
                                paddingLeading: Constants.horizontalPadding,
                                paddingTop: Constants.paddingTopTwenty,
                                paddingTrailing: -Constants.horizontalPadding,
                                height: Constants.totalAccountHeight)
    }
    
    private func configureServicesTitleView() {
        view.addSubview(servicesTitleView)
        servicesTitleView.anchor(leading: view.leadingAnchor,
                                 top: totalAccountView.bottomAnchor,
                                 trailing: view.trailingAnchor,
                                 paddingLeading: Constants.horizontalPadding,
                                 paddingTop: Constants.paddingTopTwenty,
                                 paddingTrailing: -Constants.horizontalPadding,
                                 height: Constants.servicesTitleHeight)
        servicesTitleView.setTitle(title: "Сервисы")
    }
    
    private func configureServicesCollectionView() {
        let servicesLayout = UICollectionViewFlowLayout()
        servicesLayout.scrollDirection = .horizontal
        servicesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: servicesLayout)
        guard let servicesCollectionView = servicesCollectionView else { return }
        servicesCollectionView.register(ServicesCell.self, forCellWithReuseIdentifier: ServicesCell.identifire)
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = serviceAdapter
        servicesCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(servicesCollectionView)
        servicesCollectionView.anchor(leading: view.leadingAnchor,
                                      top: servicesTitleView.bottomAnchor,
                                      trailing: view.trailingAnchor,
                                      paddingLeading: Constants.horizontalPadding,
                                      paddingTop: Constants.paddingTopTen,
                                      paddingTrailing: -Constants.horizontalPadding,
                                      height: Constants.servicesCollectionHeight)
        servicesCollectionView.backgroundColor = .white
    }
    
    private func configureTransactionTitleView() {
        guard let servicesCollectionView = servicesCollectionView else { return }
        view.addSubview(transactionTitleView)
        transactionTitleView.anchor(leading: view.leadingAnchor,
                                    top: servicesCollectionView.bottomAnchor,
                                    trailing: view.trailingAnchor,
                                    paddingLeading: Constants.horizontalPadding,
                                    paddingTop: Constants.paddingTopTen,
                                    paddingTrailing: -Constants.horizontalPadding,
                                    height: Constants.transactionTitleHeight)
        transactionTitleView.setTitle(title: "Последние транзакции")
        
        view.addSubview(noTransactionsLabel)
        noTransactionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noTransactionsLabel.anchor(top: transactionTitleView.bottomAnchor,
                                   paddingTop: Constants.paddingTopTwenty,
                                   height: Constants.noTransactionsHeight)
    }
    
    private func configureLastTransactionsCollectionView() {
        let transactionsLayout = UICollectionViewFlowLayout()
        lastTransactionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: transactionsLayout)
        guard let lastTransactionsCollectionView = lastTransactionsCollectionView else { return }
        lastTransactionsCollectionView.register(LastTransactionCell.self, forCellWithReuseIdentifier: LastTransactionCell.identifire)
        lastTransactionsCollectionView.delegate = self
        lastTransactionsCollectionView.dataSource = lastTransactionsAdapter
        lastTransactionsCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(lastTransactionsCollectionView)
        lastTransactionsCollectionView.anchor(leading: view.leadingAnchor,
                                              top: transactionTitleView.bottomAnchor,
                                              trailing: view.trailingAnchor,
                                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                              paddingLeading: Constants.horizontalPadding,
                                              paddingTop: Constants.paddingTopTwenty,
                                              paddingTrailing: -Constants.horizontalPadding,
                                              paddingBottom: -Constants.lastTransactionsPaddingBottom)
        lastTransactionsCollectionView.backgroundColor = .white
        lastTransactionsCollectionView.isHidden = true
    }
}

// MARK: - HomeInput

extension HomeViewController: HomeInput {
    func showData(total: String,
                  service: [ChoiceService],
                  lastTransaction: [Transaction]) {
//        totalAccountView.setAccountLabel(total)
        serviceAdapter.configure(service)
        servicesCollectionView?.reloadData()
        lastTransactionsAdapter.configure(transaction: lastTransaction)
        lastTransactionsCollectionView?.reloadData()
    }
    
    func showLastTransaction() {
        lastTransactionsCollectionView?.isHidden = false
    }
    
    func showAlert(message: String) {
        self.alert(with: "Ошибка", message: message)
    }
    
    func setUserName(_ name: String) {
        fullNameLabel.text = name
    }
    
    func showProgress(_ progress: Progress) {
        totalAccountView.setValue(progress)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.servicesCollectionView {
            output.showService(at: indexPath.row)
        }
        
        if collectionView == self.lastTransactionsCollectionView {
            output.showTransaction(for: indexPath.row)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.servicesCollectionView {
            return CGSize(width: Constants.servicesCollectionItemWidth,
                          height: Constants.servicesCollectionItemHeight)
        }
        guard let width = lastTransactionsCollectionView?.frame.width else { return CGSize(width: 0, height: 0) }
        return CGSize(width: width,
                      height: Constants.lastTransactionsCollectionItemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.servicesCollectionView {
            return Constants.minimumLineSpacingForServiceCollection
        }
        return Constants.minimumLineSpacingForLastTransactions
    }
}
