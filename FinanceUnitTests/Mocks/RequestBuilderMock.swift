//
//  RequestBuilderMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.11.2023.
//

import Foundation
@testable import Finance

final class RequestBuilderMock: RequestBuilderProtocol {

    var invokedBuild = false
    var invokedBuildCount = 0
    var invokedBuildParameters: (request: NetworkRequestProtocol, Void)?
    var invokedBuildParametersList = [(request: NetworkRequestProtocol, Void)]()
    var stubbedBuildError: Error?
    var stubbedBuildResult: URLRequest!

    func build(request: NetworkRequestProtocol) throws -> URLRequest {
        invokedBuild = true
        invokedBuildCount += 1
        invokedBuildParameters = (request, ())
        invokedBuildParametersList.append((request, ()))
        if let error = stubbedBuildError {
            throw error
        }
        return stubbedBuildResult
    }
}
