//
//  ExchangeRateService.swift
//  Finance
//
//  Created by Александр Меренков on 15.08.2023.
//

import Foundation

final class ExchangeRateService {
    
// MARK: - Properties
    
    private let network: NetworkProtocol
    private let config: NetworkConfiguration
    private let defaultValueService: DefaultValueServiceProtocol

    private var fullName = [String]()
    private var img = [String]()
    
// MARK: - Lifecycle
    
    init(network: NetworkProtocol, config: NetworkConfiguration,
         defaultValueService: DefaultValueServiceProtocol) {
        self.network = network
        self.config = config
        self.defaultValueService = defaultValueService
    }
}

// MARK: - ExchangeRateServiceProtocol

extension ExchangeRateService: ExchangeRateServiceProtocol {
    func fetchExchangeRate(_ requestCurrency: String, completion: @escaping (ResultStatus<[CurrentExchangeRate]>) -> Void) {
        (fullName, img) = defaultValueService.fetchExchangeValue()
        DispatchQueue.main.async {
            do {
                let urlString = try self.config.getUrl(.exchange) + requestCurrency
                guard let url = URL(string: urlString) else { return }
                let request = URLRequest(url: url)
                self.network.loadData(request: request) { (result: Result<ConversionRates, Error>) in
                    switch result {
                    case .success(let rate):
                        var index = -1
                        let exchangeRate = rate.conversion_rates.map { (name, exchangeRate) in
                            index += 1
                            return CurrentExchangeRate(name: name, amount: exchangeRate, fullName: self.fullName[index], img: self.img[index])
                        }
                        completion(.success(exchangeRate))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
}
