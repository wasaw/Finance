//
//  NewsAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 18.10.2023.
//

import UIKit

final class NewsAssembly {
    func makeNewsModule(moduleOutput: NewsPresenterOutput, newsService: NewsServiceProtocol) -> UIViewController {
        let presenter = NewsPresenter(moduleOutput: moduleOutput, newsService: newsService)
        let vc = NewsViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
