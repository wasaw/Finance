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
    var config: NetworkConfiguration!
    var defaultValueService: DefaultValueServiceMock!
    var exchangeRateService: ExchangeRateServiceProtocol!
    
    override func setUp() {
        network = NetworkServiceMock()
        config = NetworkConfiguration()
        defaultValueService = DefaultValueServiceMock()
        exchangeRateService = ExchangeRateService(network: network, config: config, defaultValueService: defaultValueService)
    }
    
    override func tearDown() {
        network = nil
        config = nil
        defaultValueService = nil
        exchangeRateService = nil
    }
    
    func testFetchExchangeRate() {
        exchangeRateService.fetchExchangeRate("USD") { [weak self] result in
            switch result {
            case .success:
                XCTAssertEqual(self?.network.invokedLoadData, true)
                XCTAssertEqual(self?.network.invokedLoadDataCount, 1)
            case .failure:
                XCTAssertThrowsError(true)
            }
        }
    }
}
