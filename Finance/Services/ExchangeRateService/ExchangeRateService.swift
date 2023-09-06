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
    func fetchExchangeRate(_ requestCurrency: String, completion: @escaping (Result<[CurrentExchangeRate], Error>) -> Void) {
        (fullName, img) = defaultValueService.fetchExchangeValue()
        DispatchQueue.main.async {
            do {
                let urlString = try self.config.getUrl(.exchange) + requestCurrency
                guard let url = URL(string: urlString) else { return }
                let request = URLRequest(url: url)
                self.network.loadData(request: request) { (result: Result<ExchangeRateDataModel, Error>) in
                    switch result {
                    case .success(let rate):
                        let exchangeRate = rate.conversionRates.enumerated().compactMap { (index, pair) in
                            return CurrentExchangeRate(name: pair.0, amount: pair.1, fullName: self.fullName[index], img: self.img[index])
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
    
    func updateExchangeRate(for currency: Currency) {
        fetchExchangeRate(currency.forRequest()) { result in
            switch result {
            case .success(let answer):
                if let currency = answer.first(where: { $0.name == "RUB" }) {
                    UserDefaults.standard.set(currency.amount, forKey: "currencyRate")
                }
            case .failure:
                UserDefaults.standard.set(1, forKey: "currencyRate")
            }
        }
    }
}
