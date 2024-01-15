//
//  ExchangeRateServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.09.2023.
//

import XCTest
@testable import Finance

final class ExchangeRateServiceTests: XCTestCase {
    
    var network: NetworkServiceMock!
    var defaultValueService: DefaultValueServiceMock!
    var exchangeRateService: ExchangeRateServiceProtocol!
    
    override func setUp() {
        network = NetworkServiceMock()
        defaultValueService = DefaultValueServiceMock()
        exchangeRateService = ExchangeRateService(network: network,
                                                  defaultValueService: defaultValueService)
    }
    
    override func tearDown() {
        network = nil
        defaultValueService = nil
        exchangeRateService = nil
    }
    
    func testFetchExchangeRate() {
        exchangeRateService.fetchExchangeRate("USD") { _ in
        }
        
        XCTAssertEqual(defaultValueService.invokedFetchExchangeValue, true)
        XCTAssertEqual(defaultValueService.invokedFetchExchangeValueCount, 1)
    }
}
