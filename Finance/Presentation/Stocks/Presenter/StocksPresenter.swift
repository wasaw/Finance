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
    
// MARK: - Lifecycle
    
    init(stocksService: StocksServiceProtocol) {
        self.stocksService = stocksService
    }
    
// MARK: - Helpers
    
    private func loadData() {
        stocksService.getStocks { result in
            switch result {
            case .success(let stocks):
                DispatchQueue.main.async {
                    self.input?.setLoading(enable: false)
                    self.input?.setData(stocks)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - StocksOutput

extension StocksPresenter: StocksOutput {
    func viewIsReady() {
        input?.setLoading(enable: true)
        loadData()
    }
}
