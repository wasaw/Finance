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
    var newsRequest: NetworkRequestMock!
    var newsService: NewsService!
    
    override func setUp() {
        networkService = NetworkServiceMock()
        newsRequest = NetworkRequestMock()
        newsService = NewsService(network: networkService)
    }
    
    override func tearDown() {
        networkService = nil
        newsService = nil
        newsRequest = nil
    }
    
    func testFetchNews() {
        let articles = [NewsDataModel.NewsArticles(title: "title",
                                                   description: "description",
                                                   url: "url",
                                                   urlToImage: "nil",
                                                   publishedAt: "2025-02-15")]
        let news = NewsDataModel(status: "true",
                                 totalResults: 2,
                                 articles: articles)
        newsService.fetchNews { result in
            switch result {
            case .success(let success):
                XCTAssertEqual(success[0].title, articles[0].title)
            case .failure:
                XCTAssertThrowsError(true)
            }
        }
        
        XCTAssert(networkService.invokedLoadData)
        XCTAssertEqual(networkService.invokedLoadDataCount, 1)
    }
}
