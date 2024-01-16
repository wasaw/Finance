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
    
// MARK: - Lifecycle
    
    init(id: UUID) {
        self.id = id
    }
    
}

// MARK: - AllTransactionOutput

extension AllTransactionsPresenter: AllTransactionsOutput {
    
}
