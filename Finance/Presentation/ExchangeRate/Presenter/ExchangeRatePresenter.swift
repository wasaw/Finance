//
//  ExchangeRatePresenter.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import Foundation

final class ExchangeRatePresenter {
    
// MARK: - Properties
    
    weak var input: ExchangeRateInput?
    
    private let network: NetworkProtocol
    private let config: NetworkConfiguration
    private let coreDataService: CoreDataServiceProtocol
    private let exchangeRateService: ExchangeRateServiceProtocol
    private var exchangeRate: [CurrentExchangeRate] = []
        
// MARK: - Lifecycle
    
    init(network: NetworkProtocol,
         config: NetworkConfiguration,
         coreDataService: CoreDataServiceProtocol,
         exchangeRateService: ExchangeRateServiceProtocol) {
        self.network = network
        self.config = config
        self.coreDataService = coreDataService
        self.exchangeRateService = exchangeRateService
    }
    
// MARK: - Helpers
    
    private func loadInformation(_ requestCurrency: String) {
        exchangeRateService.fetchExchangeRate(requestCurrency) { result in
            switch result {
            case .success(let exchangeRate):
                DispatchQueue.main.async {
                    if let currency = exchangeRate.first(where: { $0.name == "RUB" }) {
                        self.input?.setCurrency(currency: currency, requestCurrency: requestCurrency)
                    }
                    self.input?.showData(exchangeRate)
                    self.input?.setLoading(enable: false)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - ExchangeRateOutput

extension ExchangeRatePresenter: ExchangeRateOutput {
    func viewIsReady() {
        input?.setLoading(enable: true)
        loadInformation("USD")
    }
    
    func loadCurrency(_ index: Int) {
        if index < exchangeRate.count {
            loadInformation(exchangeRate[index].name)
        }
    }
}
