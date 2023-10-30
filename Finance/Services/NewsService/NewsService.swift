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
    private let config: NetworkConfiguration
    
// MARK: - Lifecycle
    
    init(network: NetworkProtocol, config: NetworkConfiguration) {
        self.network = network
        self.config = config
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
                let urlString = try config.getUrl(.news, page: index)
                guard let url = URL(string: urlString) else {
                    group.leave()
                    return
                }
                let request = URLRequest(url: url)
                network.loadData(request: request) { (result: Result<NewsDataModel, Error>) in
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
