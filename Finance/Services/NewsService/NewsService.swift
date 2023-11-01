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
    
// MARK: - Lifecycle
    
    init(network: NetworkProtocol, requestBuilder: RequestBuilderProtocol) {
        self.network = network
        self.requestBuilder = requestBuilder
    }
    
}

// MARK: - NewsServiceProtocol

extension NewsService: NewsServiceProtocol {
    func fetchNews(completion: @escaping ((Result<[News], RequestError>) -> Void)) {
        do {
            var sendNews: [News] = []
            let group = DispatchGroup()
//            Features NEWS API
            for index in 1...3 {
                group.enter()
                let urlRequest = try requestBuilder.getNewsRequest(page: index)
                network.loadData(request: urlRequest) { (result: Result<NewsDataModel, Error>) in
                    switch result {
                    case .success(let news):
                        let news: [News] = news.data.compactMap { newsData in
                            guard let url = URL(string: newsData.url),
                                  let imageUrl = URL(string: newsData.imageUrl)
                            else {
                                group.leave()
                                return nil
                            }
                            ImageCache.publicCache.load(url: url, completion: { _ in
                            })
                            return News(uuid: newsData.uuid,
                                        title: newsData.title,
                                        descriptin: newsData.description,
                                        url: url,
                                        imageUrl: imageUrl,
                                        publishedAt: newsData.publishedAt)
                        }
                        sendNews += news
                        group.leave()
                    case .failure:
                        group.leave()
                    }
                }
            }
            group.notify(queue: .main) {
                completion(.success(sendNews))
            }
        } catch {
            completion(.failure(RequestError.somethingError))
        }
    }
}
