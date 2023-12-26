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
    var stocksRequest: NetworkRequestMock!
    var stocksService: StocksServiceProtocol!
    
    override func setUp() {
        networkService = NetworkServiceMock()
        requestBuilder = RequestBuilderMock()
        defaultValueService = DefaultValueServiceMock()
        stocksRequest = NetworkRequestMock()
        stocksService  = StocksService(network: networkService,
                                       requestBuilder: requestBuilder,
                                       defaultValueService: defaultValueService,
                                       stocksRequest: stocksRequest)
    }
    
    override func tearDown() {
        networkService = nil
        requestBuilder = nil
        defaultValueService = nil
        stocksService = nil
        stocksRequest = nil
    }
    
    func testGetStocks() {
        guard let apiKey = Bundle.main.infoDictionary?["STOCK_API_KEY"] as? String,
              let url = URL(string: "https://api.polygon.io/v2/aggs/grouped/locale/us/market/stocks/2023-12-25?adjusted=true&apiKey=\(apiKey)") else {
            return
        }
        requestBuilder.stubbedBuildResult = URLRequest(url: url)
        
        stocksService.fetchStocks { _ in
        }
        
        XCTAssert(requestBuilder.invokedBuild)
        XCTAssertEqual(requestBuilder.invokedBuildCount, 1)
    }
}
