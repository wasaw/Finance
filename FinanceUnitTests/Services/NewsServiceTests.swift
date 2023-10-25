//
//  NewsServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 25.10.2023.
//

import XCTest
@testable import Finance

final class NewsServiceTests: XCTestCase {
    
    var networkService: NetworkServiceMock!
    var config: NetworkConfiguration!
    var newsService: NewsService!
    
    override func setUp() {
        networkService = NetworkServiceMock()
        config = NetworkConfiguration()
        newsService = NewsService(network: networkService, config: config)
    }
    
    override func tearDown() {
        networkService = nil
        config = nil
        newsService = nil
    }
    
    func testFetchNews() {
        newsService.fetchNews { _ in
        }
        
        XCTAssert(networkService.invokedLoadData)
        XCTAssertEqual(networkService.invokedLoadDataCount, 3)
    }
}
