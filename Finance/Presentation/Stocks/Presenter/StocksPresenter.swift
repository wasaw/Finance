//
//  StocksPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import Foundation

final class StocksPresenter {
    
// MARK: - Properties
    
    weak var input: StocksInput?
    
    private var stockList: [Stock] = [Stock(symbol: "ABNB", company: "Airbnb"),
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
    private let dayInSeconds = 86400.0
    
// MARK: - Helpers
    
    private func loadData() {
        let currentDate = Date() - dayInSeconds
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: currentDate)
        DispatchQueue.main.async {
            NetworkService.shared.loadStockRate(date: stringDate) { results in
                switch results {
                case .success(let results):
                    for i in 0..<self.stockList.count {
                        if let answer = results.first(where: { $0.symbol == self.stockList[i].symbol }) {
                            self.stockList[i].value = answer.value
                        }
                    }
                    self.input?.setLoading(enable: false)
                    self.input?.setData(self.stockList)
                case .failure(let error):
                    self.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - StocksOutput

extension StocksPresenter: StocksOutput {
    func viewIsReady() {
        input?.setLoading(enable: true)
        loadData()
    }
}
