//
//  HomeViewController.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
// MARK: - Properties
    
    private var output: HomeOutput
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваше имя"
        label.textColor = .totalTintColor
        label.font = UIFont.boldSystemFont(ofSize: 27)
        return label
    }()
    private lazy var totalAccountView = TotalAccountView()
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
    private var lastTransactionsCollectionView: UICollectionView?
    
    private var heightView: CGFloat = 0
    private var service: [ChoiceService] = []
    private var lastTransaction: [LastTransaction] = []

    
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
        
        output.viewIsReady()
        configureUI()
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
                             paddingLeading: 10,
                             paddingTrailing: -15,
                             height: 50)
    }
    
    private func configureTotalAccountView() {
        view.addSubview(totalAccountView)
//        let height = heightView / 5.5
        let height: CGFloat = 180
        totalAccountView.anchor(leading: view.leadingAnchor,
                                top: fullNameLabel.bottomAnchor,
                                trailing: view.trailingAnchor,
                                paddingLeading: 10,
                                paddingTop: 20,
                                paddingTrailing: -10,
                                height: height)
    }
    
    private func configureServicesTitleView() {
        view.addSubview(servicesTitleView)
        servicesTitleView.anchor(leading: view.leadingAnchor,
                                 top: totalAccountView.bottomAnchor,
                                 trailing: view.trailingAnchor,
                                 paddingLeading: 10,
                                 paddingTop: 25,
                                 paddingTrailing: -10,
                                 height: 20)
        servicesTitleView.setTitle(title: "Сервисы")
    }
    
    private func configureServicesCollectionView() {
        let servicesLayout = UICollectionViewFlowLayout()
        servicesLayout.scrollDirection = .horizontal
        servicesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: servicesLayout)
        guard let servicesCollectionView = servicesCollectionView else { return }
        servicesCollectionView.register(ServicesCell.self, forCellWithReuseIdentifier: ServicesCell.identifire)
        servicesCollectionView.delegate = self
        servicesCollectionView.dataSource = self
        servicesCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(servicesCollectionView)
        servicesCollectionView.anchor(leading: view.leadingAnchor,
                                      top: servicesTitleView.bottomAnchor,
                                      trailing: view.trailingAnchor,
                                      paddingLeading: 10,
                                      paddingTop: 10,
                                      paddingTrailing: -10,
                                      height: 140)
        servicesCollectionView.backgroundColor = .white
    }
    
    private func configureTransactionTitleView() {
        guard let servicesCollectionView = servicesCollectionView else { return }
        view.addSubview(transactionTitleView)
        transactionTitleView.anchor(leading: view.leadingAnchor,
                                    top: servicesCollectionView.bottomAnchor,
                                    trailing: view.trailingAnchor,
                                    paddingLeading: 10,
                                    paddingTop: 10,
                                    paddingTrailing: -10,
                                    height: 20)
        transactionTitleView.setTitle(title: "Последние транзакции")
        
        view.addSubview(noTransactionsLabel)
        noTransactionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noTransactionsLabel.anchor(top: transactionTitleView.bottomAnchor, paddingTop: 25, height: 20)
    }
    
    private func configureLastTransactionsCollectionView() {
        let transactionsLayout = UICollectionViewFlowLayout()
        lastTransactionsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: transactionsLayout)
        guard let lastTransactionsCollectionView = lastTransactionsCollectionView else { return }
        lastTransactionsCollectionView.register(LastTransactionCell.self, forCellWithReuseIdentifier: LastTransactionCell.identifire)
        lastTransactionsCollectionView.delegate = self
        lastTransactionsCollectionView.dataSource = self
        lastTransactionsCollectionView.showsVerticalScrollIndicator = false
        view.addSubview(lastTransactionsCollectionView)
        lastTransactionsCollectionView.anchor(leading: view.leadingAnchor,
                                              top: transactionTitleView.bottomAnchor,
                                              trailing: view.trailingAnchor,
                                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                              paddingLeading: 10,
                                              paddingTop: 15,
                                              paddingTrailing: -10,
                                              paddingBottom: -25)
        lastTransactionsCollectionView.backgroundColor = .white
        lastTransactionsCollectionView.isHidden = true
    }
}

// MARK: - HomeInput

extension HomeViewController: HomeInput {
    func showData(total: Double, currency: Currency, service: [ChoiceService], lastTransaction: [LastTransaction]) {
        totalAccountView.setAccountLabel(total: total, currency: currency)
        self.service = service
        servicesCollectionView?.reloadData()
        self.lastTransaction = lastTransaction
        lastTransactionsCollectionView?.reloadData()
    }
    
    func showLastTransaction() {
        lastTransactionsCollectionView?.isHidden = false
    }
    
    func showAlert(message: String) {
        self.alert(with: "Ошибка", massage: message)
    }
}

// MARK: - UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.servicesCollectionView {
            output.showService(at: indexPath.row)
//            navigationController?.pushViewController(service[indexPath.row].vc, animated: true)
        }
        
        if collectionView == self.lastTransactionsCollectionView {
//            let vc = LastTransactionModalController(transaction: lastTransaction[indexPath.row],
//                                                    currency: CurrencyRate.currentCurrency,
//                                                    rate: CurrencyRate.rate)
            let vc = LastTransactionViewController()
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 26
            }
            self.present(vc, animated: false)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.servicesCollectionView {
            return service.count
        }
        if collectionView == self.lastTransactionsCollectionView {
            return lastTransaction.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.servicesCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServicesCell.identifire,
                                                                for: indexPath) as? ServicesCell else { return UICollectionViewCell() }
            cell.setInformation(service: service[indexPath.row])
            return cell
        }
        if collectionView == self.lastTransactionsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastTransactionCell.identifire,
                                                                for: indexPath) as? LastTransactionCell else { return UICollectionViewCell() }
            cell.setInformation(lastTransaction: lastTransaction[indexPath.row], currency: CurrencyRate.currentCurrency, rate: CurrencyRate.rate)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.servicesCollectionView {
            return CGSize(width: 80, height: 110)
        }
        guard let width = lastTransactionsCollectionView?.frame.width else { return CGSize(width: 0, height: 0) }
        return CGSize(width: width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.servicesCollectionView {
            return 25
        }
        return 5
    }
}