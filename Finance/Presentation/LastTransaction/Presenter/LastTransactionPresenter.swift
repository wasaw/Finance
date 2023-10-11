//
//  LastTransactionPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 19.06.2023.
//

import Foundation

final class LastTransactionPresenter {
    
// MARK: - Properties
    
    private let transaction: Transaction
    
    weak var input: LastTransactionInput?
    
// MARK: - Lifecycle
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
}

// MARK: - LastTransactionOutput

extension LastTransactionPresenter: LastTransactionOutput {
    func viewIsReady() {
        guard let currency = UserDefaults.standard.value(forKey: "currency") as? Int,
              let currentCurrency = Currency(rawValue: currency) else { return }
        input?.showData(transaction: transaction, currency: currentCurrency)
    }
}
