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
    
    private let coreDataService: CoreDataProtocol
    private let fileStore = FileStore()
    
    private var category = [ChoiceCategoryExpense]()
    private var revenue = [ChoiceTypeRevenue]()
    
// MARK: - Lifecycle
    
    init(coreDataService: CoreDataProtocol) {
        self.coreDataService = coreDataService
    }
    
// MARK: - Helpers
    
    private func loadData() {
        fileStore.readAppInformation("category") { [weak self] (result: Result<[ChoiceCategoryExpense], FileManagerError>) in
            switch result {
            case .success(let answer):
                self?.category = answer
            case .failure(let error):
                self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
        
        fileStore.readAppInformation("revenue") { [weak self] (result: Result<[ChoiceTypeRevenue], FileManagerError>) in
            switch result {
            case .success(let answer):
                self?.revenue = answer
            case .failure(let error):
                self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
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
        coreDataService.save { context in
            let transactionManagedObject = TransactionManagedObject(context: context)
            transactionManagedObject.type = transaction.type
            transactionManagedObject.category = transaction.category
            transactionManagedObject.img = transaction.img
            transactionManagedObject.date = transaction.date
            transactionManagedObject.amount = transaction.amount
            transactionManagedObject.comment = transaction.comment
        }
        input?.dismissView()
    }
}
