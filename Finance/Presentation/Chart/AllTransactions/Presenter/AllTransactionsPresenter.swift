//
//  AllTransactionsPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 16.01.2024.
//

import Foundation

final class AllTransactionsPresenter {
    
// MARK: - Properties
    
    weak var input: AllTransactionsInput?
    private let id: UUID
    private let transactionsService: TransactionsServiceProtocol
    private let userDefaults = CustomUserDefaults.shared
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        return df
    }()
    
// MARK: - Lifecycle
    
    init(id: UUID, transactionsService: TransactionsServiceProtocol) {
        self.id = id
        self.transactionsService = transactionsService
    }
    
// MARK: - Helpers
    
    private func prepareTableData(_ transactions: [Transaction]) {
        guard let currency = userDefaults.get(for: .currency) as? Int,
              let currencyRate = userDefaults.get(for: .currencyRate) as? Double,
              let currentCurrency = Currency(rawValue: currency)?.symbol else { return }
        
        let displayData = transactions.compactMap({
            AllTransactionsCell.DisplayData(title: String(format: "%.2f",
                                                          $0.amount / currencyRate) + " \(currentCurrency)",
                                            date: dateFormatter.string(from: $0.date))
        })
        input?.setLoading(enable: false)
        input?.showData(displayData)
    }
}

// MARK: - AllTransactionOutput

extension AllTransactionsPresenter: AllTransactionsOutput {
    func viewIsReady() {
        input?.setLoading(enable: true)
        do {
            let transactions = try transactionsService.fetchTransactionsByCategory(for: id)
            prepareTableData(transactions)
        } catch {
            input?.showAlert(error.localizedDescription)
        }
    }
}
