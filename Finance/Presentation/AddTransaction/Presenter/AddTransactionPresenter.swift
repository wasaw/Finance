//
//  AddTransactionPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2023.
//

import Foundation

struct AccountCellModel {
    let title: String
    let imageData: Data
    let amount: Double
    let currency: Currency
}

struct CategoryCellModel {
    let title: String
    let imageData: Data
}

struct SaveTransaction {
    let amount: String?
    let date: Date
    let comment: String?
}

final class AddTransactionPresenter {
    
    // MARK: - Properties
    
    weak var input: AddTransactionInput?
    
    private let accountService: AccountServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private let fileStore: FileStoreProtocol
    
    private var account = [Account]()
    private var category = [Categories]()
    private var selectedAccount: Account?
    private var selectedCategory: Categories?
    private var revenueCategory: Categories?
    private var isRevenue = false
    
    private let notification = NotificationCenter.default
    private let defaults = CustomUserDefaults.shared
    
    // MARK: - Lifecycle
    
    init(accountService: AccountServiceProtocol,
         categoryService: CategoryServiceProtocol,
         transactionsService: TransactionsServiceProtocol,
         fileStore: FileStoreProtocol) {
        self.accountService = accountService
        self.categoryService = categoryService
        self.transactionsService = transactionsService
        self.fileStore = fileStore
    }
    
    deinit {
        notification.removeObserver(self)
    }
    
    // MARK: - Helpers
    
    private func loadData() {
        accountService.fetchAccounts { [weak self] result in
            switch result {
            case .success(let accounts):
                guard let currency = self?.defaults.get(for: .currency) as? Int,
                      let currencyRate = self?.defaults.get(for: .currencyRate) as? Double,
                      let currentCurrency = Currency(rawValue: currency) else { return }
                let accountCellModel: [AccountCellModel] = accounts.compactMap { account in
                    if self?.selectedAccount == nil {
                        self?.selectedAccount = account
                    }
                    self?.account.append(account)
                    return AccountCellModel(title: account.title,
                                            imageData: account.image,
                                            amount: account.amount / currencyRate,
                                            currency: currentCurrency)
                }
                self?.input?.setAccount(accountCellModel)
            case .failure(let error):
                self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
        
        categoryService.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                let categoriesCellModel = categories.compactMap { category in
                    if self?.selectedCategory == nil {
                        self?.selectedCategory = category
                    }
                    self?.category.append(category)
                    if category.title == "Прочее" {
                        self?.revenueCategory = category
                    }
                    return CategoryCellModel(title: category.title, imageData: category.image)
                }
                self?.input?.setCategory(categoriesCellModel)
            case .failure(let error):
                self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
    }
}

// MARK: - AddTransactionOutput

extension AddTransactionPresenter: AddTransactionOutput {
    func selectedAccount(_ index: Int) {
        selectedAccount = account[index]
    }
    
    func selectedCategory(_ index: Int) {
        selectedCategory = category[index]
    }
    
    func isRevenue(_ value: Bool) {
        selectedCategory = revenueCategory
        isRevenue = value
    }
    
    func viewIsReady() {
        loadData()
    }
    
    func saveTransaction(_ transaction: SaveTransaction) {
        guard let accountId = selectedAccount?.id,
              let amountString = transaction.amount,
              let categoryId = selectedCategory?.id,
              let currencyRate = defaults.get(for: .currencyRate) as? Double,
              let amount = Double(amountString) else {
            if transaction.amount == "" {
                input?.showAlert(with: "Внимание", and: "Не заполнено поле сумма")
                input?.feedBack(.error)
            }
            return
        }
        let signedAmount = isRevenue ? amount : -amount
        let convertedAmount = signedAmount * currencyRate
        let lastTransaction = Transaction(account: accountId,
                                          category: categoryId,
                                          amount: convertedAmount,
                                          date: transaction.date,
                                          comment: transaction.comment ?? "")
        transactionsService.saveTransaction(lastTransaction)
        let addTransaction: [String: Transaction] = ["lastTransaction": lastTransaction]
        notification.post(Notification(name: .addTransactions, object: nil, userInfo: addTransaction))
        input?.dismissView()
        input?.feedBack(.success)
    }
}
