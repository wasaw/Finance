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
    
    private let notification = NotificationCenter.default

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
        guard let currency = UserDefaults.standard.value(forKey: "currency") as? Int,
              let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double,
              let currentCurrency = Currency(rawValue: currency) else { return }
        for index in 0..<revenue.count {
            revenue[index].amount /= currencyRate
        }
        input?.showData(category: category,
                        revenue: revenue,
                        currency: currentCurrency,
                        currencyRate: currencyRate)
    }
}

// MARK: - AddTransactionOutput

extension AddTransactionPresenter: AddTransactionOutput {
    func viewIsReady() {
        loadData()
    }
    
    func saveTransaction(_ transaction: LastTransaction) {
        transactionsService.saveTransaction(transaction)
        let addTransaction: [String: LastTransaction] = ["lastTransaction": transaction]
        notification.post(Notification(name: Notification.Name("AddTransaction"), object: nil, userInfo: addTransaction))
        input?.dismissView()
    }
}
