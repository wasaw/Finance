//
//  RequestBuilderMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.11.2023.
//

import Foundation
@testable import Finance

final class RequestBuilderMock: RequestBuilderProtocol {

    var invokedGetExchangeRequest = false
    var invokedGetExchangeRequestCount = 0
    var invokedGetExchangeRequestParameters: (requestCurrency: String, Void)?
    var invokedGetExchangeRequestParametersList = [(requestCurrency: String, Void)]()
    var stubbedGetExchangeRequestError: Error?
    var stubbedGetExchangeRequestResult: URLRequest!

    func getExchangeRequest(_ requestCurrency: String) throws -> URLRequest {
        invokedGetExchangeRequest = true
        invokedGetExchangeRequestCount += 1
        invokedGetExchangeRequestParameters = (requestCurrency, ())
        invokedGetExchangeRequestParametersList.append((requestCurrency, ()))
        if let error = stubbedGetExchangeRequestError {
            throw error
        }
        return stubbedGetExchangeRequestResult
    }

    var invokedGetStocksRequest = false
    var invokedGetStocksRequestCount = 0
    var invokedGetStocksRequestParameters: (date: String?, Void)?
    var invokedGetStocksRequestParametersList = [(date: String?, Void)]()
    var stubbedGetStocksRequestError: Error?
    var stubbedGetStocksRequestResult: URLRequest! = URLRequest(url: URL(string: "google.com")!)

    func getStocksRequest(date: String?) throws -> URLRequest {
        invokedGetStocksRequest = true
        invokedGetStocksRequestCount += 1
        invokedGetStocksRequestParameters = (date, ())
        invokedGetStocksRequestParametersList.append((date, ()))
        if let error = stubbedGetStocksRequestError {
            throw error
        }
        return stubbedGetStocksRequestResult
    }

    var invokedGetNewsRequest = false
    var invokedGetNewsRequestCount = 0
    var invokedGetNewsRequestParameters: (page: Int, Void)?
    var invokedGetNewsRequestParametersList = [(page: Int, Void)]()
    var stubbedGetNewsRequestError: Error?
    var stubbedGetNewsRequestResult: URLRequest! = URLRequest(url: URL(string: "google.com")!)

    func getNewsRequest(page: Int) throws -> URLRequest {
        invokedGetNewsRequest = true
        invokedGetNewsRequestCount += 1
        invokedGetNewsRequestParameters = (page, ())
        invokedGetNewsRequestParametersList.append((page, ()))
        if let error = stubbedGetNewsRequestError {
            throw error
        }
        return stubbedGetNewsRequestResult
    }
}
