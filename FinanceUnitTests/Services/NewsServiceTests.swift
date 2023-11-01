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
    var requestBuilder: RequestBuilderMock!
    var newsService: NewsService!
    
    override func setUp() {
        networkService = NetworkServiceMock()
        requestBuilder = RequestBuilderMock()
        newsService = NewsService(network: networkService, requestBuilder: requestBuilder)
    }
    
    override func tearDown() {
        networkService = nil
        requestBuilder = nil
        newsService = nil
    }
    
    func testFetchNews() {
        newsService.fetchNews { _ in
        }
        
        XCTAssert(networkService.invokedLoadData)
        XCTAssertEqual(networkService.invokedLoadDataCount, 3)
        XCTAssert(requestBuilder.invokedGetNewsRequest)
        XCTAssertEqual(requestBuilder.invokedGetNewsRequestCount, 3)
    }
}
