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
    var config: NetworkConfiguration!
    var defaultValueService: DefaultValueServiceMock!
    var stocksService: StocksServiceProtocol!
    
    override func setUp() {
        networkService = NetworkServiceMock()
        config = NetworkConfiguration()
        defaultValueService = DefaultValueServiceMock()
        stocksService  = StocksService(network: networkService,
                                       config: config,
                                       defaultValueService: defaultValueService)
    }
    
    override func tearDown() {
        networkService = nil
        config = nil
        defaultValueService = nil
        stocksService = nil
    }
    
    func testGetStocks() {
        stocksService.getStocks { _ in
        }
        
        XCTAssertEqual(defaultValueService.invokedFetchStocks, true)
        XCTAssertEqual(defaultValueService.invokedFetchStocksCount, 1)
    }
}
