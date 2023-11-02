//
//  ExchangeRateRequest.swift
//  Finance
//
//  Created by Александр Меренков on 02.11.2023.
//

import Foundation

final class ExchangeRateRequest: NetworkRequestProtocol {
    private let apiKey = Bundle.main.infoDictionary?["EXCHANGE_API_KEY"] as? String ?? ""
    
    var httpMethod: HTTPMethod = .get
    var host: String = "v6.exchangerate-api.com"
    var path: String {
        "/v6/" + apiKey + "/latest/" + (requestValue)
    }
    var requestValue: String = "USD"
}
