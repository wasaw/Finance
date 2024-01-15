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
    var defaultValueService: DefaultValueServiceMock!
    var stocksService: StocksServiceProtocol!
    
    override func setUp() {
        networkService = NetworkServiceMock()
        defaultValueService = DefaultValueServiceMock()
        stocksService  = StocksService(network: networkService,
                                       defaultValueService: defaultValueService)
    }
    
    override func tearDown() {
        networkService = nil
        defaultValueService = nil
        stocksService = nil
    }
    
    func testGetStocks() {
        let stock = Stock(symbol: "$",
                          company: "AAPL")
        stocksService.fetchStocks { result in
            switch result {
            case .success(let success):
                XCTAssertEqual(success[0].company, stock.company)
            case .failure:
                XCTAssertThrowsError(true)
            }
        }
    }
}
