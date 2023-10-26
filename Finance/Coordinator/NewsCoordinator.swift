//
//  NewsCoordinator.swift
//  Finance
//
//  Created by Александр Меренков on 25.10.2023.
//

import UIKit

final class NewsCoordinator {
    
// MARK: - Properties
    
    private let newsAssembly: NewsAssembly
    private let newsService: NewsServiceProtocol
    private var viewController: UIViewController?
    
// MARK: - Lifecycle
    
    init(newsAssembly: NewsAssembly, newsService: NewsServiceProtocol) {
        self.newsAssembly = newsAssembly
        self.newsService = newsService
    }
    
// MARK: - Helpers
    
    func start() -> UIViewController {
        let vc = newsAssembly.makeNewsModule(output: self, newsService: newsService)
        viewController = vc
        return vc
    }
}

// MARK: - NewsPresenterOutput

extension NewsCoordinator: NewsPresenterOutput {
    func showWebView(for url: URL) {
        let show = WebKitController(url: url)
        viewController?.present(show, animated: true)
    }
}
