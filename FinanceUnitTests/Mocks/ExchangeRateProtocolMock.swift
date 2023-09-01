//
//  ExchangeRateProtocolMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.09.2023.
//

import Foundation
@testable import Finance

final class ExchangeRateProtocolMock: ExchangeRateServiceProtocol {

    var invokedFetchExchangeRate = false
    var invokedFetchExchangeRateCount = 0
    var invokedFetchExchangeRateParameters: (requestCurrency: String, Void)?
    var invokedFetchExchangeRateParametersList = [(requestCurrency: String, Void)]()
    var stubbedFetchExchangeRateCompletionResult: (Result<[CurrentExchangeRate], Error>, Void)?

    func fetchExchangeRate(_ requestCurrency: String, completion: @escaping (Result<[CurrentExchangeRate], Error>) -> Void) {
        invokedFetchExchangeRate = true
        invokedFetchExchangeRateCount += 1
        invokedFetchExchangeRateParameters = (requestCurrency, ())
        invokedFetchExchangeRateParametersList.append((requestCurrency, ()))
        if let result = stubbedFetchExchangeRateCompletionResult {
            completion(result.0)
        }
    }

    var invokedUpdateExchangeRate = false
    var invokedUpdateExchangeRateCount = 0
    var invokedUpdateExchangeRateParameters: (currency: Currency, Void)?
    var invokedUpdateExchangeRateParametersList = [(currency: Currency, Void)]()

    func updateExchangeRate(for currency: Currency) {
        invokedUpdateExchangeRate = true
        invokedUpdateExchangeRateCount += 1
        invokedUpdateExchangeRateParameters = (currency, ())
        invokedUpdateExchangeRateParametersList.append((currency, ()))
    }
}
