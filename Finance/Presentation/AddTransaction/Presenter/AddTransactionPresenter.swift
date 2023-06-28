//
//  AddTransactionPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2023.
//

import Foundation

final class AddTransactionPresenter {
    
// MARK: - Properties
    
    weak var input: AddTransactionInput?
    
    private let transactionsService: TransactionsServiceProtocol
    private let defaultValueService: DefaultValueServiceProtocol
    
    private var category = [ChoiceCategoryExpense]()
    private var revenue = [ChoiceTypeRevenue]()
    
// MARK: - Lifecycle
    
    init(transactionsService: TransactionsServiceProtocol, defaultValueService: DefaultValueServiceProtocol) {
        self.transactionsService = transactionsService
        self.defaultValueService = defaultValueService
    }
    
// MARK: - Helpers
    
    private func loadData() {
        do {
            (category, revenue) = try defaultValueService.fetchValue()
        } catch {
            input?.showAlert(with: "Ошибка", and: error.localizedDescription)
        }
        input?.showData(category: category, revenue: revenue)
    }
}

// MARK: - AddTransactionOutput

extension AddTransactionPresenter: AddTransactionOutput {
    func viewIsReady() {
        loadData()
    }
    
    func saveTransaction(_ transaction: LastTransaction) {
        transactionsService.saveTransaction(transaction)
        input?.dismissView()
    }
}
