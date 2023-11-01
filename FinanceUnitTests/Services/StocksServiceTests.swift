//
//  StocksServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.09.2023.
//

import XCTest
@testable import Finance

final class StocksServiceTests: XCTestCase {
    
    var networkService: NetworkServiceMock!
    var requestBuilder: RequestBuilderMock!
    var defaultValueService: DefaultValueServiceMock!
    var stocksService: StocksServiceProtocol!
    
    override func setUp() {
        networkService = NetworkServiceMock()
        requestBuilder = RequestBuilderMock()
        defaultValueService = DefaultValueServiceMock()
        stocksService  = StocksService(network: networkService,
                                       requestBuilder: requestBuilder,
                                       defaultValueService: defaultValueService)
    }
    
    override func tearDown() {
        networkService = nil
        requestBuilder = nil
        defaultValueService = nil
        stocksService = nil
    }
    
    func testGetStocks() {
        stocksService.fetchStocks { _ in
        }
        
        XCTAssert(requestBuilder.invokedGetStocksRequest)
        XCTAssertEqual(requestBuilder.invokedGetStocksRequestCount, 1)
    }
}
