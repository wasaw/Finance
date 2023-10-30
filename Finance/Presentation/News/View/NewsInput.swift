//
//  NewsInput.swift
//  Finance
//
//  Created by Александр Меренков on 18.10.2023.
//

import Foundation

protocol NewsInput: AnyObject {
    func setLoading(enable: Bool)
    func setNews(_ news: [NewsItem])
    func showAlert(with message: String)
}
