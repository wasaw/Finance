//
//  NetworkService.swift
//  Finance
//
//  Created by Александр Меренков on 11.07.2022.
//

import Alamofire

enum RequestType {
    case exchange
    case stock
}

final class NetworkService {
    static let shared = NetworkService()
    
//    MARK: - Properties
    
    private let config = NetworkConfiguration()

//    MARK: - Helpers
    
    func loadExchangeRates(requestCurrency: String, complition: @escaping(ConversionRates) -> Void) {
        let urlRequest = config.getUrl(.exchange) + requestCurrency
        AF.request(urlRequest).responseDecodable(of: ConversionRates.self) { response in
            guard let result = response.value else { return }
            complition(result)
        }
    }
    
    func loadStockRate(date: String, complition: @escaping([StockItem]) -> Void) {
        let urlRequest = config.getUrl(.stock, date: date)
        AF.request(urlRequest).responseDecodable(of: StockRate.self) { response in
            guard let result = response.value else { return }
            complition(result.results)
        }
    }
}
