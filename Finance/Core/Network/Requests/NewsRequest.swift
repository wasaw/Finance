//
//  NewsRequest.swift
//  Finance
//
//  Created by Александр Меренков on 02.11.2023.
//

import Foundation

final class NewsRequest: NetworkRequestProtocol {
    private let apiKey = Bundle.main.infoDictionary?["NEWS_API_KEY"] as? String ?? ""
    
    var httpMethod: HTTPMethod = .get
    var host: String = "newsapi.org"
    var path: String {
        "/v2/top-headlines?country=us&apiKey=" + apiKey
    }
    var requestValue: String = ""
}
