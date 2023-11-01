//
//  StocksServiceMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.09.2023.
//

import Foundation
@testable import Finance

final class StocksServiceMock: StocksServiceProtocol {
    var invokedGetStocks = false
    var invokedGetStocksCount = 0
    var stubbedGetStocksCompletionResult: (Result<[Stock], Error>, Void)?

    func fetchStocks(completion: @escaping ((Result<[Stock], Error>) -> Void)) {
        invokedGetStocks = true
        invokedGetStocksCount += 1
        if let result = stubbedGetStocksCompletionResult {
            completion(result.0)
        }
    }
}
