//
//  ExchangeRateController.swift
//  Finance
//
//  Created by Александр Меренков on 08.07.2022.
//

import UIKit

final class ExchangeRateController: UIViewController {
    
// MARK: - Properties
    
    private let topView = TopView()
    private let loadAnimateView = CircleAnimation()
    private var listCurrencyCollectionView: UICollectionView?
    private let networkService = NetworkService.shared
    private let databaseService = DatabaseService.shared
    private var exchangeRate = [CurrentExchangeRate]()
    private let fullName = ["Болгарский лев",
                            "Чешская крона",
                            "Евро",
                            "Фунт стерлингов",
                            "Казахстанский тенге",
                            "Новозеландский доллар",
                            "Рубль",
                            "Доллар"]
    private let img = ["bulgarian-lev.png",
                       "czech-republic.png",
                       "euro.png",
                       "pound-sterling.png",
                       "kazakhstani-tenge.png",
                       "new-zealand.png",
                       "ruble-currency.png",
                       "dollar.png"]
    private var revenue: Double = 0
    private var currentRate: Double = 0
    private var requestCurrency = "USD"
    private var isLoadExchange = false {
        didSet {
            setTotalAccount()
        }
    }
    private var isLoadRevenue = false {
        didSet {
            setTotalAccount()
        }
    }
    
// MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoadAnimationView()
        loadInformation(requestCurrency)
        configureUI()
        configureCollectionView()
        
        view.backgroundColor = .white
    }
    
// MARK: - Helpers
    
    private func configureLoadAnimationView() {
        topView.addSubview(loadAnimateView)
        loadAnimateView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        loadAnimateView.anchor(top: topView.safeAreaLayoutGuide.topAnchor)
        loadAnimateView.configureAnimation()
    }
    
    private func loadInformation(_ requestCurrency: String) {
        networkService.loadExchangeRates(requestCurrency: requestCurrency, complition: { response in
            switch response {
            case .success(let response):
                var index = 0
                self.exchangeRate = []
                for item in response.conversion_rates {
                    let currency = CurrentExchangeRate(name: item.0, amount: item.1, fullName: self.fullName[index], img: self.img[index])
                    self.exchangeRate.append(currency)
                    if currency.name == "RUB" {
                        self.topView.setCurrency(currency, requestCurrency: requestCurrency)
                        self.currentRate = currency.amount
                    }
                    index += 1
                }
                self.isLoadExchange = true
                self.listCurrencyCollectionView?.reloadData()
                self.loadAnimateView.isHidden = true
            case .failure(let error):
                self.alert(with: "Ошибка", massage: error.localizedDescription)
            }
        })
        
        DispatchQueue.main.async {
            self.databaseService.getTypeInformation { result in
                switch result {
                case .success(let revenue):
                    let revenueArray = revenue
                    var amount: Double = 0
                    for item in revenueArray {
                        amount += item.amount
                    }
                    self.revenue = amount
                    self.isLoadRevenue = true
                case .failure(let error):
                    self.alert(with: "Ошибка", massage: error.localizedDescription)
                }
            }
        }
    }
    
    private func configureUI() {
        view.addSubview(topView)
        topView.anchor(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, height: 350)
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
        
        listCurrencyCollectionView.anchor(left: view.leftAnchor, top: topView.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: -15)
    }
    
    private func setTotalAccount() {
        if isLoadExchange && isLoadRevenue {
            let total = revenue / currentRate
            topView.setTotalAccount(total)
        }
    }
}

// MARK: - UICollectionVIewDelegate

extension ExchangeRateController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        requestCurrency = exchangeRate[indexPath.row].name
        loadInformation(requestCurrency)
    }
}

// MARK: - UICollectionViewDataSource

extension ExchangeRateController: UICollectionViewDataSource {
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

extension ExchangeRateController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
}
