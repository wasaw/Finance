//
//  StocksPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import Foundation

final class StocksPresenter {
    
// MARK: - Properties
    
    weak var input: StocksInput?
    private let stocksService: StocksServiceProtocol
    private var stocks: [Stock]?
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(stocksService: StocksServiceProtocol) {
        self.stocksService = stocksService
        notification.addObserver(self,
                                 selector: #selector(updateData),
                                 name: .updateCurrency,
                                 object: nil)
    }
    
    deinit {
        notification.removeObserver(self)
    }
    
// MARK: - Helpers
    
    private func loadData() {
        stocksService.getStocks { [weak self] result in
            switch result {
            case .success(let stocks):
                self?.handleStocksResponse(stocks)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
    }
    
    private func handleStocksResponse(_ stocks: [Stock]) {
        self.stocks = stocks
        DispatchQueue.main.async {
            self.input?.setLoading(enable: false)
            self.input?.setData(stocks)
        }
    }
    
// MARK: - Selectors
    
    @objc private func updateData() {
        guard let stocks = stocks else { return }
        input?.setData(stocks)
    }
}

// MARK: - StocksOutput

extension StocksPresenter: StocksOutput {
    func viewIsReady() {
        input?.setLoading(enable: true)
        loadData()
    }
}
