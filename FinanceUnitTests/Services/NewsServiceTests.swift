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
    var newsRequest: NetworkRequestMock!
    var newsService: NewsService!
    
    override func setUp() {
        networkService = NetworkServiceMock()
        requestBuilder = RequestBuilderMock()
        newsRequest = NetworkRequestMock()
        newsService = NewsService(network: networkService,
                                  requestBuilder: requestBuilder,
                                  newsRequest: newsRequest)
    }
    
    override func tearDown() {
        networkService = nil
        requestBuilder = nil
        newsService = nil
        newsRequest = nil
    }
    
    func testFetchNews() {
        guard let apiKey = Bundle.main.infoDictionary?["NEWS_API_KEY"] as? String,
              let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)") else { return }
        requestBuilder.stubbedBuildResult = URLRequest(url: url)
        newsService.fetchNews { _ in
        }
        
        XCTAssert(networkService.invokedLoadData)
        XCTAssertEqual(networkService.invokedLoadDataCount, 1)
    }
}
