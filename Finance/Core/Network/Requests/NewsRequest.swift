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
    var host: String = "api.marketaux.com"
    var path: String {
        "/v1/news/all?countries=us&filter_entities=true&limit=10" + "$page=" + requestValue + "&published_after=2023-10-31T13:25&api_token=" + apiKey
    }
    var requestValue: String = ""
}
