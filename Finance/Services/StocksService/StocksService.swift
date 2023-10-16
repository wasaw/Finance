//
//  StocksService.swift
//  Finance
//
//  Created by Александр Меренков on 15.08.2023.
//

import Foundation

final class StocksService {
    
// MARK: - Properties
    
    private let network: NetworkProtocol
    private let config: NetworkConfiguration
    private let defaultValueService: DefaultValueServiceProtocol
    
    private var dayInSeconds = 86400.0
    
// MARK: - Lifecycle
    
    init(network: NetworkProtocol,
         config: NetworkConfiguration,
         defaultValueService: DefaultValueServiceProtocol) {
        self.network = network
        self.config = config
        self.defaultValueService = defaultValueService
    }
}

// MARK: - StocksServiceProtocol

extension StocksService: StocksServiceProtocol {
    func getStocks(completion: @escaping ((Result<[Stock], Error>) -> Void)) {
        let currentWeekday = Calendar.current.dateComponents([.weekday], from: Date())
// Limitation API
        if  currentWeekday.weekday == 2 || currentWeekday.weekday == 1 {
            dayInSeconds = 259200
        }
        let currentDate = Date() - dayInSeconds
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: currentDate)
        var stockList = defaultValueService.fetchStocks()
        DispatchQueue.main.async {
            do {
                let urlString = try self.config.getUrl(.stock, date: stringDate)
                guard let url = URL(string: urlString) else { return }
                let urlRequest = URLRequest(url: url)
                self.network.loadData(request: urlRequest) { (result: Result<StockRateDataModel, Error>) in
                    switch result {
                    case .success(let stocks):
                        let result = stocks.results
                        for (index, stock) in stockList.enumerated() {
                            if let answer = result.first(where: { $0.symbol == stock.symbol }) {
                                stockList[index].value = answer.value
                            }
                        }
                        completion(.success(stockList))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
