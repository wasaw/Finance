//
//  DefaultValue.swift
//  Finance
//
//  Created by Александр Меренков on 26.06.2023.
//

import Foundation

final class DefaultValue {
    
// MARK: - setDefaultValue

    private let revenue = [ChoiceTypeRevenue(name: "Зарплата", img: "calendar.png"),
               ChoiceTypeRevenue(name: "Продажа", img: "sales.png"),
               ChoiceTypeRevenue(name: "Проценты", img: "price-tag.png"),
               ChoiceTypeRevenue(name: "Наличные", img: "salary.png"),
               ChoiceTypeRevenue(name: "Вклад", img: "deposit.png"),
               ChoiceTypeRevenue(name: "Иное", img: "other.png")]

    private let category = [ChoiceCategoryExpense(name: "Продукты", img: "products.png"),
                ChoiceCategoryExpense(name: "Транспорт", img: "transportation.png"),
                ChoiceCategoryExpense(name: "Образование", img: "education.png"),
                ChoiceCategoryExpense(name: "Подписки", img: "subscription.png"),
                ChoiceCategoryExpense(name: "Прочее", img: "other.png"),
                ChoiceCategoryExpense(name: "Связь", img: "chat.png"),
                ChoiceCategoryExpense(name: "Развлечения", img: "cinema.png"),
                ChoiceCategoryExpense(name: "Ресторан", img: "fast-food.png"),
                ChoiceCategoryExpense(name: "Здоровье", img: "healthcare.png")]
    
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
        
        fileStore.readAppInformation("revenue") { [weak self] (result: Result<[ChoiceTypeRevenue], FileManagerError>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                switch error {
                case .fileNotExists:
                    self?.fileStore.setAppInformation(filename: "revenue", file: self?.revenue)
                }
            }
        }
        
        fileStore.readAppInformation("category") { [weak self] (result: Result<[ChoiceCategoryExpense], FileManagerError>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                switch error {
                case .fileNotExists:
                    self?.fileStore.setAppInformation(filename: "category", file: self?.category)
                }
            }
        }
        
        fileStore.readAppInformation("stocks") { [weak self] (result: Result<[Stock], FileManagerError>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                switch error {
                case .fileNotExists:
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
                case .fileNotExists:
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
                case .fileNotExists:
                    self?.fileStore.setAppInformation(filename: "exchangeImg", file: self?.exchangeImg)
                }
            }
        }
    }
}
