//
//  NewsPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 18.10.2023.
//

import Foundation

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
        newsService.fetchNews()
    }
}
