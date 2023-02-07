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
    
    func loadExchangeRates(requestCurrency: String, complition: @escaping(ResultStatus<ConversionRates>) -> Void) {
        let urlRequest = config.getUrl(.exchange) + requestCurrency
        AF.request(urlRequest).responseDecodable(of: ConversionRates.self) { response in
            if let error = response.error {
                complition(.failure(RequestError.somethingError))
            }
            guard let result = response.value else { return }
            complition(.success(result))
        }
    }
    
    func loadStockRate(date: String, complition: @escaping(ResultStatus<[StockItem]>) -> Void) {
        let urlRequest = config.getUrl(.stock, date: "2023-02-03")
        AF.request(urlRequest).responseDecodable(of: StockRate.self) { response in
            if let _ = response.error {
                complition(.failure(RequestError.somethingError))
            }
            guard let result = response.value else { return }
            complition(.success(result.results))
        }
    }
}
