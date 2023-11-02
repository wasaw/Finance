//
//  NewsService.swift
//  Finance
//
//  Created by Александр Меренков on 18.10.2023.
//

import Foundation

final class NewsService {
    
// MARK: - Properties
    
    private let network: NetworkProtocol
    private let requestBuilder: RequestBuilderProtocol
    private let newsRequest: NetworkRequestProtocol
    
// MARK: - Lifecycle
    
    init(network: NetworkProtocol,
         requestBuilder: RequestBuilderProtocol,
         newsRequest: NetworkRequestProtocol) {
        self.network = network
        self.requestBuilder = requestBuilder
        self.newsRequest = newsRequest
    }
    
}

// MARK: - NewsServiceProtocol

extension NewsService: NewsServiceProtocol {
    func fetchNews(completion: @escaping ((Result<[News], RequestError>) -> Void)) {
        do {
            let urlRequest = try requestBuilder.build(request: newsRequest)
            network.loadData(request: urlRequest) { (result: Result<NewsDataModel, Error>) in
                switch result {
                case .success(let news):
                    let news: [News] = news.articles.compactMap { newsData in
                        guard let url = URL(string: newsData.url),
                              let urlToImage = newsData.urlToImage,
                              let imageUrl = URL(string: urlToImage),
                              let description = newsData.description
                        else {
                            return nil
                        }
                        ImageCache.publicCache.load(url: url, completion: { _ in
                        })
                        return News(title: newsData.title,
                                    descriptin: description,
                                    url: url,
                                    imageUrl: imageUrl,
                                    publishedAt: newsData.publishedAt)
                    }
                    completion(.success(news))
                case .failure:
                    completion(.failure(RequestError.somethingError))
                }
            }
        } catch {
            completion(.failure(RequestError.somethingError))
        }
    }
}
