//
//  NetworkServiceMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.09.2023.
//

import Foundation
@testable import Finance

final class NetworkServiceMock: NetworkProtocol {

    var invokedLoadData = false
    var invokedLoadDataCount = 0
    var invokedLoadDataParameters: (request: URLRequest, Void)?
    var invokedLoadDataParametersList = [(request: URLRequest, Void)]()
    typealias T = Any
    var stubbedLoadDataCompletionResult: (Result<T, Error>, Void)?

    func loadData<T: Decodable>(request: URLRequest, completion: @escaping(Result<T, Error>) -> Void) {
        invokedLoadData = true
        invokedLoadDataCount += 1
        invokedLoadDataParameters = (request, ())
        invokedLoadDataParametersList.append((request, ()))
        if let result = stubbedLoadDataCompletionResult {
            completion(result.0 as! Result<T, Error>)
        }
    }
}
