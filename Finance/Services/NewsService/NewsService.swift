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
    func fetchNews() {
        do {
            let urlString = try config.getUrl(.news)
            guard let url = URL(string: urlString) else { return }
            let request = URLRequest(url: url)
            network.loadData(request: request) { (result: Result<NewsDataModel, Error>) in
                switch result {
                case .success(let news):
                    print("DEBUG: news \(news)")
                case .failure:
                    break
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
