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
    let id = UUID()
    let title: String
    let imageUrl: URL
    let date: String
}

final class NewsPresenter {
    
// MARK: - Properties
    
    weak var input: NewsInput?
    private let output: NewsPresenterOutput
    private let newsService: NewsServiceProtocol
    private var news: [News]
    
// MARK: - Lifecycle
    
    init(output: NewsPresenterOutput, newsService: NewsServiceProtocol) {
        self.output = output
        self.newsService = newsService
        self.news = []
    }
    
// MARK: - Helpers
    
    private func transformNews(_ news: [News]) -> [NewsItem] {
        return news.map { news in
            let index = news.publishedAt.index(news.publishedAt.startIndex, offsetBy: 10)
            let dateSubstring = news.publishedAt.prefix(upTo: index)
            let date = String(dateSubstring)
            return NewsItem(title: news.title, imageUrl: news.imageUrl, date: date)
        }
    }
    
    private func loadNews() {
        news = []
        newsService.fetchNews { [weak self] result in
            switch result {
            case .success(let news):
                let newsItem = self?.transformNews(news) ?? []
                self?.input?.setLoading(enable: false)
                self?.input?.setNews(newsItem)
                self?.news = news
            case .failure:
                self?.input?.setLoading(enable: false)
                self?.input?.showAlert(with: "Попробуйте загрузить снова.")
            }
        }
    }
}

// MARK: - NewsOutput

extension NewsPresenter: NewsOutput {
    func viewIsReady() {
        input?.setLoading(enable: true)
        loadNews()
    }
    
    func updateData() {
        loadNews()
    }
    
    func showWebView(for index: Int) {
        guard index <= news.count else { return }
        output.showWebView(for: news[index].url)
    }
}
