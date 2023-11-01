//
//  NetworkConfiguration.swift
//  Finance
//
//  Created by Александр Меренков on 31.01.2023.
//

import Foundation

final class RequestBuilder {
    
// MARK: - Properties
    
    private let exchangeUrl = "https://v6.exchangerate-api.com/v6/"
    private let exchangeApiKey = Bundle.main.infoDictionary?["EXCHANGE_API_KEY"] as? String ?? ""
    private let exchangeEnd = "/latest/"
    
    private let stockUrl = "https://api.polygon.io/v2/aggs/grouped/locale/us/market/stocks/"
    private let stockCenter = "?adjusted=true&apiKey="
    private let stockApiKey = Bundle.main.infoDictionary?["STOCK_API_KEY"] as? String ?? ""
    
    private let newsUrl = "https://api.marketaux.com/v1/news/all?countries=us&filter_entities=true&limit=10"
    private let newsEnd = "&published_after=2023-10-31T13:25&api_token="
    private let newsApiKey = Bundle.main.infoDictionary?["NEWS_API_KEY"] as? String ?? ""
}

// MARK: - RequestBuilderProtocol

extension RequestBuilder: RequestBuilderProtocol {
    func getExchangeRequest(_ requestCurrency: String) throws -> URLRequest {
        if exchangeApiKey.isEmpty {
            throw NetworkError.cantBuildUrl
        }
        let requst = exchangeUrl + exchangeApiKey + exchangeEnd + requestCurrency
        guard let url = URL(string: requst) else {
            throw NetworkError.cantBuildUrl
        }
        return URLRequest(url: url)
    }
    
    func getStocksRequest(date: String?) throws -> URLRequest {
        guard let date = date,
              !stockApiKey.isEmpty else {
            throw NetworkError.cantBuildUrl
        }
        let request = stockUrl + date + stockCenter + stockApiKey
        guard let url = URL(string: request) else {
            throw NetworkError.cantBuildUrl
        }
        return URLRequest(url: url)
    }
    
    func getNewsRequest(page: Int) throws -> URLRequest {
        if newsApiKey.isEmpty {
            throw NetworkError.cantBuildUrl
        }
        let request = newsUrl + "$page=\(page)" + newsEnd + newsApiKey
        guard let url = URL(string: request) else {
            throw NetworkError.cantBuildUrl
        }
        return URLRequest(url: url)
    }
}
