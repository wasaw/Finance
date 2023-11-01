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
    
    private let coreDataService: CoreDataServiceProtocol
    private let exchangeRateService: ExchangeRateServiceProtocol
    private var exchangeRate: [CurrentExchangeRate] = []
    private let notification = NotificationCenter.default
        
// MARK: - Lifecycle
    
    init(coreDataService: CoreDataServiceProtocol,
         exchangeRateService: ExchangeRateServiceProtocol) {
        self.coreDataService = coreDataService
        self.exchangeRateService = exchangeRateService
        notification.addObserver(self, selector: #selector(updateInformation), name: .updateCurrency, object: nil)
    }
    
    deinit {
        notification.removeObserver(self)
    }
    
// MARK: - Helpers
    
    private func loadInformation(_ requestCurrency: String) {
        exchangeRateService.fetchExchangeRate(requestCurrency) { [weak self] result in
            switch result {
            case .success(let exchangeRate):
                self?.handleExchangeRateResponse(exchangeRate, requestCurrency)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
    }
    
    private func handleExchangeRateResponse(_ exchangeRate: [CurrentExchangeRate], _ requestCurrency: String) {
        self.exchangeRate = exchangeRate
        DispatchQueue.main.async {
            if let currency = exchangeRate.first(where: { $0.name == "RUB" }) {
                self.input?.setCurrency(currency: currency, requestCurrency: requestCurrency)
            }
            self.input?.showData(exchangeRate)
            self.input?.setLoading(enable: false)
        }
    }
    
// MARK: - Selectors
    
    @objc private func updateInformation() {
        loadInformation("USD")
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
