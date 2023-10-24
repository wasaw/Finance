//
//  NewsPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 18.10.2023.
//

import Foundation

enum Section: Hashable, CaseIterable {
    case section
}

struct NewsItem: Hashable {
    let id: String
    let title: String
    let imageUrl: URL
    let date: String
}

final class NewsPresenter {
    
// MARK: - Properties
    
    weak var input: NewsInput?
    private let newsService: NewsServiceProtocol
    
// MARK: - Lifecycle
    
    init(newsService: NewsServiceProtocol) {
        self.newsService = newsService
    }
}

// MARK: - NewsOutput

extension NewsPresenter: NewsOutput {
    func viewIsReady() {
        input?.setLoading(enable: true)
        newsService.fetchNews { [weak self] result in
            switch result {
            case .success(let news):
                let itemNews = news.map { news in
                    let index = news.publishedAt.index(news.publishedAt.startIndex, offsetBy: 10)
                    let dateSubstring = news.publishedAt.prefix(upTo: index)
                    let date = String(dateSubstring)
                    return NewsItem(id: news.uuid, title: news.title, imageUrl: news.imageUrl, date: date)
                }
                self?.input?.setLoading(enable: false)
                self?.input?.setNews(itemNews)
            case .failure:
                break
            }
        }
    }
}
