//
//  StocksRequest.swift
//  Finance
//
//  Created by Александр Меренков on 02.11.2023.
//

import Foundation

final class StocksRequest: NetworkRequestProtocol {
    private let apiKey = Bundle.main.infoDictionary?["STOCK_API_KEY"] as? String ?? ""
    var httpMethod: HTTPMethod = .get
    var host: String = "api.polygon.io"
    var path: String {
        "/v2/aggs/grouped/locale/us/market/stocks/" + requestValue + "?adjusted=true&apiKey=" + apiKey
    }
    var requestValue: String = ""
}
