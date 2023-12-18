//
//  DefaultValue.swift
//  Finance
//
//  Created by Александр Меренков on 26.06.2023.
//

import Foundation

final class DefaultValue {
    
// MARK: - setDefaultValue
    
    private let stocks = [Stock(symbol: "ABNB", company: "Airbnb"),
                          Stock(symbol: "AAPL", company: "Apple"),
                          Stock(symbol: "AMZN", company: "Amazon"),
                          Stock(symbol: "CSCO", company: "Cisco"),
                          Stock(symbol: "GM", company: "General Motors"),
                          Stock(symbol: "GOOG", company: "Alphabet"),
                          Stock(symbol: "KO", company: "Coca-Cola"),
                          Stock(symbol: "MA", company: "Mastercard"),
                          Stock(symbol: "MCD", company: "McDonald's"),
                          Stock(symbol: "MSFT", company: "Microsoft"),
                          Stock(symbol: "NKE", company: "Nike"),
                          Stock(symbol: "NVDA", company: "NVIDIA"),
                          Stock(symbol: "PEP", company: "PepsiCo"),
                          Stock(symbol: "PFE", company: "Pfizer"),
                          Stock(symbol: "TSLA", company: "Tesla"),
                          Stock(symbol: "UBER", company: "Uber"),
                          Stock(symbol: "XOM", company: "Exxon"),
                          Stock(symbol: "WMT", company: "Walmart")]
    
    private let exchangeFullName = ["Болгарский лев",
                            "Чешская крона",
                            "Евро",
                            "Фунт стерлингов",
                            "Казахстанский тенге",
                            "Новозеландский доллар",
                            "Рубль",
                            "Доллар"]
    private let exchangeImg = ["bulgarian-lev.png",
                       "czech-republic.png",
                       "euro.png",
                       "pound-sterling.png",
                       "kazakhstani-tenge.png",
                       "new-zealand.png",
                       "ruble-currency.png",
                       "dollar.png"]

    private let fileStore: FileStoreProtocol

    init(fileStore: FileStoreProtocol) {
        self.fileStore = fileStore
        
        fileStore.readAppInformation("stocks") { [weak self] (result: Result<[Stock], FileManagerError>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                switch error {
                case .fileNotExists, .notRead:
                    self?.fileStore.setAppInformation(filename: "stocks", file: self?.stocks)
                }
            }
        }
        
        fileStore.readAppInformation("exchangeFullName") { [weak self] (result: Result<[String], FileManagerError>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                switch error {
                case .fileNotExists, .notRead:
                    self?.fileStore.setAppInformation(filename: "exchangeFullName", file: self?.exchangeFullName)
                }
            }
        }
        
        fileStore.readAppInformation("exchangeImg") { [weak self] (result: Result<[String], FileManagerError>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                switch error {
                case .fileNotExists, .notRead:
                    self?.fileStore.setAppInformation(filename: "exchangeImg", file: self?.exchangeImg)
                }
            }
        }
        
        if UserDefaults.standard.value(forKey: "currencyRate") == nil {
            UserDefaults.standard.set(1, forKey: "currencyRate")
            UserDefaults.standard.set(0, forKey: "currency")
        }
    }
}
