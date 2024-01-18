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
    private let requestBuilder: RequestBuilderProtocol
    private let defaultValueService: DefaultValueServiceProtocol
    private let exchanteRequest: NetworkRequestProtocol
    
    private let defaults = CustomUserDefaults.shared
    
    private var fullName = [String]()
    private var img = [String]()
    
// MARK: - Lifecycle
    
    init(network: NetworkProtocol,
         defaultValueService: DefaultValueServiceProtocol) {
        self.network = network
        self.requestBuilder = RequestBuilder.shared
        self.defaultValueService = defaultValueService
        self.exchanteRequest = ExchangeRateRequest()
    }
    
// MARK: - Helpers
    
    private func load(urlRequest: URLRequest, completion: @escaping ((Result<[CurrentExchangeRate], Error>) -> Void)) {
        network.loadData(request: urlRequest) { (result: Result<ExchangeRateDataModel, Error>) in
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
    }
}

// MARK: - ExchangeRateServiceProtocol

extension ExchangeRateService: ExchangeRateServiceProtocol {
    func fetchExchangeRate(_ requestCurrency: String, completion: @escaping (Result<[CurrentExchangeRate], Error>) -> Void) {
        (fullName, img) = defaultValueService.fetchExchangeValue()
        do {
            exchanteRequest.requestValue = requestCurrency
            let urlRequest = try requestBuilder.build(request: exchanteRequest)
            DispatchQueue.main.async {
                self.load(urlRequest: urlRequest, completion: completion)
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func updateExchangeRate(for currency: Currency, completion: @escaping (Result<Void, Error>) -> Void) {
        fetchExchangeRate(currency.request) { [weak self] result in
            switch result {
            case .success(let answer):
                if let currency = answer.first(where: { $0.name == "RUB" }) {
                    self?.defaults.set(currency.amount, key: .currencyRate)
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                }
            case .failure:
                self?.defaults.set(1, key: .currencyRate)
                completion(.failure(SaveError.dontSave))
            }
        }
    }
}
