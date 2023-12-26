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
    var requestBuilder: RequestBuilderMock!
    var defaultValueService: DefaultValueServiceMock!
    var exchangeRequest: NetworkRequestMock!
    var exchangeRateService: ExchangeRateServiceProtocol!
    
    override func setUp() {
        network = NetworkServiceMock()
        requestBuilder = RequestBuilderMock()
        defaultValueService = DefaultValueServiceMock()
        exchangeRequest = NetworkRequestMock()
        exchangeRateService = ExchangeRateService(network: network,
                                                  requestBuilder: requestBuilder,
                                                  defaultValueService: defaultValueService,
                                                  exchangeRequest: exchangeRequest)
    }
    
    override func tearDown() {
        network = nil
        requestBuilder = nil
        defaultValueService = nil
        exchangeRateService = nil
        exchangeRequest = nil
    }
    
    func testFetchExchangeRate() {
        guard let apiKey = Bundle.main.infoDictionary?["EXCHANGE_API_KEY"] as? String,
              let url = URL(string: "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/USD") else { return }
        requestBuilder.stubbedBuildResult = URLRequest(url: url)
        exchangeRateService.fetchExchangeRate("USD") { _ in
        }
        
        XCTAssertEqual(defaultValueService.invokedFetchExchangeValue, true)
        XCTAssertEqual(defaultValueService.invokedFetchExchangeValueCount, 1)
    }
}
