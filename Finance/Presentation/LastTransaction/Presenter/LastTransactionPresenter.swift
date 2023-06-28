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
    
    weak var input: LastTransactionInput?
    
}

// MARK: - LastTransactionOutput

extension LastTransactionPresenter: LastTransactionOutput {
    func viewIsReady() {
        input?.showData(transaction: transaction, currency: currency, rate: rate)
    }
}
