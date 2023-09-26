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
    
    private var revenue = [ChoiceTypeRevenue]()
    private var category = [ChoiceCategoryExpense]()
    private var selectedRevenue: ChoiceTypeRevenue?
    private var selectedCategory: ChoiceCategoryExpense?
    private var isRevenue = false
        
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
            selectedCategory = category.first
            selectedRevenue = revenue.first
        } catch {
            input?.showAlert(with: "Ошибка", and: error.localizedDescription)
        }
        guard let currency = UserDefaults.standard.value(forKey: "currency") as? Int,
              let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double,
              let currentCurrency = Currency(rawValue: currency) else { return }
        for index in 0..<revenue.count {
            do {
                let amount = try transactionsService.fetchAmountBy(revenue[index].name)
                revenue[index].amount = amount / currencyRate
            } catch {
                revenue[index].amount = 0
            }
        }
        input?.showData(category: category,
                        revenue: revenue,
                        currency: currentCurrency,
                        currencyRate: currencyRate)
    }
}

// MARK: - AddTransactionOutput

extension AddTransactionPresenter: AddTransactionOutput {
    func selectedRevenue(_ index: Int) {
        selectedRevenue = revenue[index]
    }
    
    func selectedCategory(_ index: Int) {
        selectedCategory = category[index]
    }
    
    func isRevenue(_ value: Bool) {
        isRevenue = value
    }
    
    func viewIsReady() {
        loadData()
    }
    
    func saveTransaction(_ transaction: SaveTransaction) {
        guard let type = selectedRevenue?.name,
              let amountString = transaction.amount,
              let img = selectedCategory?.img,
              let category = selectedCategory?.name,
              let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double,
              var amount = Double(amountString) else {
            if transaction.amount == "" {
                input?.showAlert(with: "Внимание", and: "Не заполнено поле сумма")
            }
            return
        }
        if !isRevenue {
            amount *= -1
        }
        amount *= currencyRate
        let lastTransaction = Transaction(type: type,
                                              amount: amount,
                                              img: img,
                                              date: transaction.date,
                                              comment: transaction.comment ?? "",
                                              category: category)
        transactionsService.saveTransaction(lastTransaction)
        let addTransaction: [String: Transaction] = ["lastTransaction": lastTransaction]
        notification.post(Notification(name: Notification.Name("addTransaction"), object: nil, userInfo: addTransaction))
        input?.dismissView()
    }
}
