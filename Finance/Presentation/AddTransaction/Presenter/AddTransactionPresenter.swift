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
    
    private let databaseService = DatabaseService.shared
    
    private var category = [ChoiceCategoryExpense]()
    private var revenue = [ChoiceTypeRevenue]()
    
// MARK: - Helpers
    
    private func loadData() {
        DispatchQueue.main.async {
            self.databaseService.getCategoryInformation { result in
                switch result {
                case .success(let category):
                    self.category = category
                    self.databaseService.getTypeInformation { result in
                        switch result {
                        case .success(let revenue):
                            self.revenue = revenue
                            self.input?.showData(category: category,
                                                 revenue: revenue)
                        case .failure(let error):
                            self.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    self.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - AddTransactionOutput

extension AddTransactionPresenter: AddTransactionOutput {
    func viewIsReady() {
        loadData()
    }
    
    func saveTransaction(_ transaction: LastTransaction) {
        databaseService.saveTransaction(transaction: transaction) { result in
            switch result {
            case .success:
                self.input?.dismissView()
            case .failure(let error):
                self.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
}
