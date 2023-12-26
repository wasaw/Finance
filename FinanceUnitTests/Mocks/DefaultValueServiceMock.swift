//
//  DefaultValueServiceMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.09.2023.
//

import Foundation
@testable import Finance

final class DefaultValueServiceMock: DefaultValueServiceProtocol {

    var invokedSaveValue = false
    var invokedSaveValueCount = 0

    func saveValue() {
        invokedSaveValue = true
        invokedSaveValueCount += 1
    }

    var invokedFetchStocks = false
    var invokedFetchStocksCount = 0
    var stubbedFetchStocksResult: [Stock]! = []

    func fetchStocks() -> [Stock] {
        invokedFetchStocks = true
        invokedFetchStocksCount += 1
        return stubbedFetchStocksResult
    }

    var invokedFetchExchangeValue = false
    var invokedFetchExchangeValueCount = 0
    var stubbedFetchExchangeValueResult: ([String], [String])! = ([], [])

    func fetchExchangeValue() -> ([String], [String]) {
        invokedFetchExchangeValue = true
        invokedFetchExchangeValueCount += 1
        return stubbedFetchExchangeValueResult
    }
}
