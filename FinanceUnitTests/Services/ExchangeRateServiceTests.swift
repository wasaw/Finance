//
//  ExchangeRateServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.09.2023.
//

import XCTest
@testable import Finance

final class ExchangeRateServiceTests: XCTestCase {
    
    var exchangeRateService: ExchangeRateProtocolMock!
    
    override func setUp() {
         exchangeRateService = ExchangeRateProtocolMock()
    }
    
    override func tearDown() {
        exchangeRateService = nil
    }
    
    func testFetchExchangeRate() {
        exchangeRateService.fetchExchangeRate("USD") { [weak self] result in
            switch result {
            case .success:
                XCTAssertEqual(self?.exchangeRateService.invokedFetchExchangeRate, true)
                XCTAssertEqual(self?.exchangeRateService.invokedFetchExchangeRateCount, 1)
            case .failure:
                XCTAssertThrowsError(true)
            }
        }
    }
    
    func testUpdateExchangeRate() {
        exchangeRateService.fetchExchangeRate("EUR") { [weak self] result in
            switch result {
            case .success:
                XCTAssertEqual(self?.exchangeRateService.invokedUpdateExchangeRate, true)
                XCTAssertEqual(self?.exchangeRateService.invokedUpdateExchangeRateCount, 1)
            case .failure:
                XCTAssertThrowsError(true)
            }
        }
    }
}
