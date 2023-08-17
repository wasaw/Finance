//
//  LastTransactionPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 19.06.2023.
//

import Foundation

final class LastTransactionPresenter {
    
// MARK: - Properties
    
    private let transaction: LastTransaction = LastTransaction(type: "Зарплата", amount: 200, img: "", date: Date(), comment: "", category: "Продукты")
    private let currency: Currency = .rub
    private let rate: Double = 20
//    private let transaction: LastTransaction
//    private let currency: Currency
//    private let rate: Double
    
    weak var input: LastTransactionInput?
    
// MARK: - Lifecycle
    
//    init(transaction: LastTransaction,
//         currency: Currency,
//         rate: Double) {
//        self.transaction = transaction
//        self.currency = currency
//        self.rate = rate
//    }
    
}

// MARK: - LastTransactionOutput

extension LastTransactionPresenter: LastTransactionOutput {
    func viewIsReady() {
        input?.showData(transaction: transaction, currency: currency, rate: rate)
    }
}
