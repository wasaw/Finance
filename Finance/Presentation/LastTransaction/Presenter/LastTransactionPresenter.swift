//
//  LastTransactionPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 19.06.2023.
//

import Foundation

final class LastTransactionPresenter {
    
// MARK: - Properties
    
    weak var input: LastTransactionInput?

    private let transaction: Transaction
        
// MARK: - Lifecycle
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
}

// MARK: - LastTransactionOutput

extension LastTransactionPresenter: LastTransactionOutput {
    func viewIsReady() {
        input?.showData(transaction: transaction)
    }
}
