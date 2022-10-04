//
//  NetworkService.swift
//  Finance
//
//  Created by Александр Меренков on 11.07.2022.
//

import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
//    MARK: - Properties
    
    private let url = "https://v6.exchangerate-api.com/v6/"
    private let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    private let end = "/latest/"
    
//    MARK: - Helpers
    
    func loadExchangeRates(requestCurrency: String, complition: @escaping(ConversionRates) -> Void) {
        let urlRequest = url + apiKey + end + requestCurrency
        AF.request(urlRequest).responseDecodable(of: ConversionRates.self) { response in
            guard let result = response.value else { return }
            complition(result)
        }
    }
}
