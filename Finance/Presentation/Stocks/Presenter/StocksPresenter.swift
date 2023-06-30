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
    private let network: NetworkProtocol
    private let config: NetworkConfiguration

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
    
// MARK: - Lifecycle
    
    init(network: NetworkProtocol, config: NetworkConfiguration) {
        self.network = network
        self.config = config
    }
    
// MARK: - Helpers
    
    private func loadData() {
        let currentDate = Date() - dayInSeconds
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: currentDate)
        DispatchQueue.main.async {
            do {
                let urlString = try self.config.getUrl(.stock, date: stringDate)
                guard let url = URL(string: urlString) else { return }
                let urlRequest = URLRequest(url: url)
                self.network.loadData(request: urlRequest) { (result: Result<StockRate, Error>) in
                    switch result {
                    case .success(let stocks):
                        let result = stocks.results
                        for i in 0..<self.stockList.count {
                            if let answer = result.first(where: { $0.symbol == self.stockList[i].symbol }) {
                                self.stockList[i].value = answer.value
                            }
                        }
                        DispatchQueue.main.async {
                            self.input?.setLoading(enable: false)
                            self.input?.setData(self.stockList)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                        }
                    }
                }
            } catch {
                self.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
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
