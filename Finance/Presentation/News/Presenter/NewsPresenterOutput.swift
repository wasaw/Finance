//
//  NewsPresenterOutput.swift
//  Finance
//
//  Created by Александр Меренков on 25.10.2023.
//

import Foundation

protocol NewsPresenterOutput: AnyObject {
    func showWebView(for url: URL)
}
