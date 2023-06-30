//
//  NetworkConfiguration.swift
//  Finance
//
//  Created by Александр Меренков on 31.01.2023.
//

import Foundation

struct NetworkConfiguration {
    
// MARK: - Properties
    
    private let exchangeUrl = "https://v6.exchangerate-api.com/v6/"
    private let exchangeApiKey = Bundle.main.infoDictionary?["EXCHANGE_API_KEY"] as? String ?? ""
    private let exchangeEnd = "/latest/"
    
    private let stockUrl = "https://api.polygon.io/v2/aggs/grouped/locale/us/market/stocks/"
    private let stockCenter = "?adjusted=true&apiKey="
    private let stockApiKey = Bundle.main.infoDictionary?["STOCK_API_KEY"] as? String ?? ""
    
// MARK: - Helpers
    
    func getUrl(_ request: RequestType, date: String? = nil) throws -> String {
        switch request {
        case .exchange:
            if exchangeApiKey.isEmpty {
                throw ConfigFileError.lostFile
            }
            return exchangeUrl + exchangeApiKey + exchangeEnd
        case .stock:
            guard let date = date else { return "" }
            if stockApiKey.isEmpty {
                throw ConfigFileError.lostFile
            }
            return stockUrl + date + stockCenter + stockApiKey
        }
    }
}
