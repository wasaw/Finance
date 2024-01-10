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
    private let requestBuilder: RequestBuilderProtocol
    private let defaultValueService: DefaultValueServiceProtocol
    private let stocksRequest: NetworkRequestProtocol
    
    private var dayInSeconds = 86400.0
    
// MARK: - Lifecycle
    
    init(network: NetworkProtocol,
         defaultValueService: DefaultValueServiceProtocol) {
        self.network = network
        self.requestBuilder = RequestBuilder.shared
        self.defaultValueService = defaultValueService
        self.stocksRequest = StocksRequest()
    }
    
// MARK: - Helpers
    
    private func load(urlRequest: URLRequest, completion: @escaping ((Result<[Stock], Error>) -> Void)) {
        var stockList = defaultValueService.fetchStocks()
        network.loadData(request: urlRequest) { (result: Result<StockRateDataModel, Error>) in
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
    }
}

// MARK: - StocksServiceProtocol

extension StocksService: StocksServiceProtocol {
    func fetchStocks(completion: @escaping ((Result<[Stock], Error>) -> Void)) {
        let currentWeekday = Calendar.current.dateComponents([.weekday], from: Date())
// Limitation API
        if  currentWeekday.weekday == 2 || currentWeekday.weekday == 1 {
            dayInSeconds = 259200
        }
        let currentDate = Date() - dayInSeconds
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = formatter.string(from: currentDate)
            do {
                stocksRequest.requestValue = stringDate
                let urlRequest = try requestBuilder.build(request: stocksRequest)
                DispatchQueue.main.async {
                    self.load(urlRequest: urlRequest, completion: completion)
                }
            } catch {
                completion(.failure(error))
            }
    }
}
