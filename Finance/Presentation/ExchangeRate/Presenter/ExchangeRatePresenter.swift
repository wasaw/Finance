//
//  ExchangeRatePresenter.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import Foundation

final class ExchangeRatePresenter {
    
// MARK: - Properties
    
    weak var input: ExchangeRateInput?
    
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
    private var currentRate: Double = 0
    private var revenue: Double = 0
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
    
// MARK: - Helpers
    
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
                        self.input?.setCurrency(currency: currency, requestCurrency: requestCurrency)
                        self.currentRate = currency.amount
                    }
                    index += 1
                }
                self.isLoadExchange = true
                self.input?.showData(self.exchangeRate)
                self.input?.setLoading(enable: false)
            case .failure(let error):
                self.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
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
                    self.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
    }
    
    private func setTotalAccount() {
        if isLoadExchange && isLoadRevenue {
            let total = revenue / currentRate
            input?.setTotalAccount(total)
        }
    }
}

// MARK: - ExchangeRateOutput

extension ExchangeRatePresenter: ExchangeRateOutput {
    func viewIsReady() {
        input?.setLoading(enable: true)
        loadInformation(requestCurrency)
    }
    
    func loadCurrency(_ requestCurrency: String) {
        loadInformation(requestCurrency)
    }
}
