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
    let currencyRate: Double
}

struct CategoryCellModel {
    let title: String
    let imageData: Data
}

final class AddTransactionPresenter {
    
    // MARK: - Properties
    
    weak var input: AddTransactionInput?
    
    private let accountService: AccountServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private let fileStore: FileStoreProtocol
    
    private var account = [Account]()
    private var category = [Category]()
    private var selectedAccount: Account?
    private var selectedCategory: Category?
    private var isRevenue = false
    
    private let notification = NotificationCenter.default
    
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
                guard let currency = UserDefaults.standard.value(forKey: "currency") as? Int,
                      let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double,
                      let currentCurrency = Currency(rawValue: currency) else { return }
                let accountCellModel: [AccountCellModel] = accounts.compactMap { account in
                    var data: Data = Data()
                    self?.fileStore.getImage(account.id.uuidString) { result in
                        switch result {
                        case .success(let imageData):
                            data = imageData
                        case .failure(let error):
                            self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                        }
                    }
                    self?.account.append(account)
                    return AccountCellModel(title: account.title,
                                            imageData: data,
                                            amount: account.amount,
                                            currency: currentCurrency,
                                            currencyRate: currencyRate)
                }
                self?.input?.setAccount(accountCellModel)
            case .failure(let error):
                self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
            }
        }
        
        categoryService.fetchCategory { [weak self] result in
            switch result {
            case .success(let categories):
                let categoriesCellModel = categories.compactMap { category in
                    var data: Data = Data()
                    self?.fileStore.getImage(category.id.uuidString) { result in
                        switch result {
                        case .success(let imageData):
                            data = imageData
                        case .failure(let error):
                            self?.input?.showAlert(with: "Ошибка", and: error.localizedDescription)
                        }
                    }
                    self?.category.append(category)
                    return CategoryCellModel(title: category.title, imageData: data)
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
        isRevenue = value
    }
    
    func viewIsReady() {
        loadData()
    }
    
    func saveTransaction(_ transaction: SaveTransaction) {
//        guard let type = selectedAccount?.name,
//              let amountString = transaction.amount,
//              let img = selectedCategory?.img,
//              let category = selectedCategory?.name,
//              let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double,
//              let amount = Double(amountString) else {
//            if transaction.amount == "" {
//                input?.showAlert(with: "Внимание", and: "Не заполнено поле сумма")
//            }
//            return
//        }
//        let signedAmount = isRevenue ? amount : -amount
//        let convertedAmount = signedAmount * currencyRate
//
//        let lastTransaction = Transaction(type: type,
//                                              amount: convertedAmount,
//                                              img: img,
//                                              date: transaction.date,
//                                              comment: transaction.comment ?? "",
//                                              category: category)
//        transactionsService.saveTransaction(lastTransaction)
//        let addTransaction: [String: Transaction] = ["lastTransaction": lastTransaction]
//        notification.post(Notification(name: .addTransactions, object: nil, userInfo: addTransaction))
//        input?.dismissView()
    }
}
