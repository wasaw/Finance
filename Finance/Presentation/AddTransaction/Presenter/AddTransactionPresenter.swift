//
//  AddTransactionPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2023.
//

import Foundation

struct AccountCellModel {
    let title: String
    let image: Data
    let amount: Double
    let currency: Currency
    let currencyRate: Double
}

final class AddTransactionPresenter {
    
// MARK: - Properties
    
    weak var input: AddTransactionInput?
    
    private let accountService: AccountServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private let defaultValueService: DefaultValueServiceProtocol
    private let fileStore: FileStoreProtocol
    
    private var revenue = [ChoiceTypeRevenue]()
    private var category = [ChoiceCategoryExpense]()
    private var selectedRevenue: ChoiceTypeRevenue?
    private var selectedCategory: ChoiceCategoryExpense?
    private var isRevenue = false
        
    private let notification = NotificationCenter.default

// MARK: - Lifecycle
    
    init(accountService: AccountServiceProtocol,
         transactionsService: TransactionsServiceProtocol,
         defaultValueService: DefaultValueServiceProtocol,
         fileStore: FileStoreProtocol) {
        self.accountService = accountService
        self.transactionsService = transactionsService
        self.defaultValueService = defaultValueService
        self.fileStore = fileStore
    }
    
    deinit {
        notification.removeObserver(self)
    }
    
// MARK: - Helpers
    
    private func loadData() {
        do {
            (category, _) = try defaultValueService.fetchValue()
            selectedCategory = category.first
            accountService.fetchAccounts { [weak self] result in
                switch result {
                case .success(let accounts):
                    guard let currency = UserDefaults.standard.value(forKey: "currency") as? Int,
                          let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double,
                          let currentCurrency = Currency(rawValue: currency) else { return }
                    let accountModelView: [AccountCellModel] = accounts.compactMap { account in
                        var data: Data = Data()
                        self?.fileStore.getImage(account.id.uuidString) { result in
                            switch result {
                            case .success(let imageData):
                                data = imageData
                            case .failure(let error):
                                self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                            }
                        }
                        return AccountCellModel(title: account.title,
                                                image: data,
                                                amount: account.amount,
                                                currency: currentCurrency,
                                                currencyRate: currencyRate)
                    }
                    self?.input?.setAccount(accountModelView)
                case .failure(let error):
                    self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                }
            }
//            selectedRevenue = revenue.first
        } catch {
            input?.showAlert(with: "Ошибка", and: error.localizedDescription)
        }
        guard let currency = UserDefaults.standard.value(forKey: "currency") as? Int,
              let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double,
              let currentCurrency = Currency(rawValue: currency) else { return }
        for (index, type) in revenue.enumerated() {
            do {
                let amount = try transactionsService.fetchAmountBy(type.name)
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
              let amount = Double(amountString) else {
            if transaction.amount == "" {
                input?.showAlert(with: "Внимание", and: "Не заполнено поле сумма")
            }
            return
        }
        let signedAmount = isRevenue ? amount : -amount
        let convertedAmount = signedAmount * currencyRate
        
        let lastTransaction = Transaction(type: type,
                                              amount: convertedAmount,
                                              img: img,
                                              date: transaction.date,
                                              comment: transaction.comment ?? "",
                                              category: category)
        transactionsService.saveTransaction(lastTransaction)
        let addTransaction: [String: Transaction] = ["lastTransaction": lastTransaction]
        notification.post(Notification(name: .addTransactions, object: nil, userInfo: addTransaction))
        input?.dismissView()
    }
}
