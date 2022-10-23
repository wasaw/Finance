//
//  HomeController.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

class HomeController: UIViewController {
    
//    MARK: - Properties
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваше имя"
        label.textColor = .totalTintColor
        label.font = UIFont.boldSystemFont(ofSize: 27)
        return label
    }()
    
    private let totalAccountView = TotalAccountView()
    private let servicesTitleView = TitleView()
    private let transactionTitleView = TitleView()
    
    private var servicesCollectionView: UICollectionView?
    private var lastTransactionsCollectionView: UICollectionView?
    
    private let noTransactionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Пока нет ни одной записи"
        label.textColor = .totalTintColor
        return label
    }()
    
    private var heightView: CGFloat = 0
    private let databaseService = DatabaseService.shared
    private let networkService = NetworkService.shared
    private let service = [ChoiceService(name: "Курс валют", img: "exchange-rate.png", vc: ExchangeRateController()), ChoiceService(name: "Акции", img: "stock-market.png", vc: StocksController())]

    private var lastTransaction = [LastTransaction]() {
        didSet {
            lastTransactionsCollectionView?.reloadData()
        }
    }
    
    private var currentUser = CurrentUser()
    
//    MARK: - Lifecycle
    
    init(_ currentUser: CurrentUser) {
        super.init(nibName: nil, bundle: nil)
        
        self.currentUser = currentUser
        self.currentUser.subscribe(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInformation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadInformation()

        heightView = view.frame.height
        configureUI()
        view.backgroundColor = .white
    }
    
//    MARK: - Helpers
    
    private func loadInformation() {
        DispatchQueue.main.async {
            self.lastTransaction = self.databaseService.getTransactionInformation()
            if !self.lastTransaction.isEmpty {
                self.lastTransactionsCollectionView?.isHidden = false
            }
            let revenueArray = self.databaseService.getTypeInformation()
            var revenue: Double = 0
            for item in revenueArray {
                revenue += item.amount
            }
            if CurrencyRate.currentCurrency == .dollar {
                revenue = revenue / CurrencyRate.usd
            }
            if CurrencyRate.currentCurrency == .euro {
                revenue = revenue / CurrencyRate.eur
            }
            self.totalAccountView.setAccountLabel(total: revenue, currency: CurrencyRate.currentCurrency)
        }
    }
    
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
        fullNameLabel.anchor(left: view.leftAnchor, top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: -15, height: 50)
    }
    
    private func configureTotalAccountView() {
        view.addSubview(totalAccountView)
        let height = heightView / 5.5
        totalAccountView.anchor(left: view.leftAnchor, top: fullNameLabel.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 20, paddingRight: -10, height: height)
    }
    
    private func configureServicesTitleView() {
        view.addSubview(servicesTitleView)
        servicesTitleView.anchor(left: view.leftAnchor, top: totalAccountView.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 25, paddingRight: -10, height: 20)
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
        servicesCollectionView.anchor(left: view.leftAnchor, top: servicesTitleView.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: 10, height: 140)
        servicesCollectionView.backgroundColor = .white
    }
    
    private func configureTransactionTitleView() {
        guard let servicesCollectionView = servicesCollectionView else { return }
        view.addSubview(transactionTitleView)
        transactionTitleView.anchor(left: view.leftAnchor, top: servicesCollectionView.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, height: 20)
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
        lastTransactionsCollectionView.anchor(left: view.leftAnchor, top: transactionTitleView.bottomAnchor, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingLeft: 10, paddingTop: 15, paddingRight: -10, paddingBottom: -25)
        lastTransactionsCollectionView.backgroundColor = .white
        lastTransactionsCollectionView.isHidden = true
    }
}

//  MARK: - Extensions

extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.servicesCollectionView {
            navigationController?.pushViewController(service[indexPath.row].vc, animated: true)
        }
        
        if collectionView == self.lastTransactionsCollectionView {
            let vc = LastTransactionModalController(transaction: lastTransaction[indexPath.row], currency: CurrencyRate.currentCurrency, rate: CurrencyRate.rate)
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 26
            }
            self.present(vc, animated: false)
        }
    }
}

extension HomeController: UICollectionViewDataSource {
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServicesCell.identifire, for: indexPath) as? ServicesCell else { return UICollectionViewCell() }
            cell.setInformation(service: service[indexPath.row])
            return cell
        }
        if collectionView == self.lastTransactionsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LastTransactionCell.identifire, for: indexPath) as? LastTransactionCell else { return UICollectionViewCell() }
            cell.setInformation(lastTransaction: lastTransaction[indexPath.row], currency: CurrencyRate.currentCurrency, rate: CurrencyRate.rate)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.servicesCollectionView {
            return CGSize(width: 80, height: 110)
        }
        guard let width = lastTransactionsCollectionView?.frame.width else { return CGSize(width: 0, height: 0) }
        return CGSize(width: width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.servicesCollectionView {
            return 25
        }
        return 5
    }
}

extension HomeController: Subscriber {
    func update(subject: User?) {
        if let user = subject {
            fullNameLabel.text = user.login
        } else {
            fullNameLabel.text = "Ваше имя"
        }
    }
}
