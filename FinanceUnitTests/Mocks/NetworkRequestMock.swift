//
//  NetworkRequestMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 26.12.2023.
//

import Foundation
@testable import Finance

final class NetworkRequestMock: NetworkRequestProtocol {

    var invokedHttpMethodGetter = false
    var invokedHttpMethodGetterCount = 0
    var stubbedHttpMethod: HTTPMethod!

    var httpMethod: HTTPMethod {
        invokedHttpMethodGetter = true
        invokedHttpMethodGetterCount += 1
        return stubbedHttpMethod
    }

    var invokedHostGetter = false
    var invokedHostGetterCount = 0
    var stubbedHost: String! = ""

    var host: String {
        invokedHostGetter = true
        invokedHostGetterCount += 1
        return stubbedHost
    }

    var invokedPathGetter = false
    var invokedPathGetterCount = 0
    var stubbedPath: String! = ""

    var path: String {
        invokedPathGetter = true
        invokedPathGetterCount += 1
        return stubbedPath
    }

    var invokedRequestValueSetter = false
    var invokedRequestValueSetterCount = 0
    var invokedRequestValue: String?
    var invokedRequestValueList = [String]()
    var invokedRequestValueGetter = false
    var invokedRequestValueGetterCount = 0
    var stubbedRequestValue: String! = ""

    var requestValue: String {
        set {
            invokedRequestValueSetter = true
            invokedRequestValueSetterCount += 1
            invokedRequestValue = newValue
            invokedRequestValueList.append(newValue)
        }
        get {
            invokedRequestValueGetter = true
            invokedRequestValueGetterCount += 1
            return stubbedRequestValue
        }
    }
}
