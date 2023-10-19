//
//  NewsServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 18.10.2023.
//

import Foundation

protocol NewsServiceProtocol: AnyObject {
    func fetchNews(completion: @escaping ((Result<[News], Error>) -> Void))
}
