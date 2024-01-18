//
//  HomePresenter.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2023.
//

import Foundation

struct TransactionCellModel {
    let category: String
    let image: Data
    let amount: String
    let date: String
    let comment: String
    let isRevenue: Bool
}

final class HomePresenter {
    
// MARK: - Properties
    
    weak var input: HomeInput?
    private weak var moduleOutput: HomePresenterOutput?
    private let accountService: AccountServiceProtocol
    private let transactionsService: TransactionsServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let userService: UserServiceProtocol
    
    private let service = [ChoiceService(name: "Траты", img: "pie-chart.png", type: .chart),
                           ChoiceService(name: "Курс валют", img: "exchange-rate.png", type: .exchange),
                           ChoiceService(name: "Акции", img: "stock-market.png", type: .stocks),
                           ChoiceService(name: "Банкоматы", img: "atm-machine", type: .atm),
                           ChoiceService(name: "Новости", img: "newspaper", type: .news)]

    private var lastTransaction = [Transaction]()
    private var balance: Double?
    private var currencyRate: Double?
    private var currentCurrency: Currency?
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        return df
    }()
    
    private let notification = NotificationCenter.default
    private let defaults = CustomUserDefaults.shared
    
// MARK: - Lifecycle
    
    init(homeCoordinator: HomePresenterOutput,
         accountService: AccountServiceProtocol,
         transactionsService: TransactionsServiceProtocol,
         categoryService: CategoryServiceProtocol,
         userService: UserServiceProtocol) {
        self.moduleOutput = homeCoordinator
        self.accountService = accountService
        self.transactionsService = transactionsService
        self.categoryService = categoryService
        self.userService = userService
        registerNotification()
    }
    
    deinit {
        notification.removeObserver(self)
    }

// MARK: - Helpers
    
    private func registerNotification() {
        notification.addObserver(self, selector: #selector(reloadView), name: .addTransactions, object: nil)
        notification.addObserver(self, selector: #selector(updateCredential(_:)), name: .updateCredential, object: nil)
        notification.addObserver(self, selector: #selector(updateCurrency), name: .updateCurrency, object: nil)
        notification.addObserver(self, selector: #selector(updateTransactions), name: .updateTransactions, object: nil)
        notification.addObserver(self, selector: #selector(updateProgress), name: .updateProgress, object: nil)
    }
    
    private func loadInformation() {
        defaultsValue()
        userInformation()
        totalAmount()
        do {
            lastTransaction = try transactionsService.fetchTransactions(limit: 5)
            prepareTransactionCellModel(lastTransaction)
        } catch {
            self.input?.showAlert(message: error.localizedDescription)
        }
        showProgress()
    }
    
    private func userInformation() {
        if let uid = defaults.get(for: .uid) as? String {
            userService.getUser(uid) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.input?.setUserName(user.login)
                case .failure:
                    self?.input?.setUserName("Здравствуйте")
                }
            }
        }
    }
    
    private func totalAmount() {
        accountService.fetchAccounts { [weak self] result in
            switch result {
            case .success(let accounts):
                let total = accounts.reduce(0) { $0 + $1.amount }
                self?.balance = total
                guard let currencyRate = self?.currencyRate,
                      let currentCurrency = self?.currentCurrency else { return }
                let showTotal = String(format: "%.2f", total / currencyRate) + currentCurrency.symbol
                self?.input?.showTotal(showTotal)
            case .failure(let error):
                self?.input?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func defaultsValue() {
        guard let currency = defaults.get(for: .currency) as? Int else { return }
        currencyRate = defaults.get(for: .currencyRate) as? Double
        currentCurrency = Currency(rawValue: currency)
    }
    
    private func showProgress(_ addTransaction: Transaction? = nil) {
        let isProgress = defaults.get(for: .isProgress) as? Bool
        if isProgress == true,
           let purpose = defaults.get(for: .expenseLimit) as? Double {
            do {
                let transactions = try transactionsService.fetchTransactionByMonth()
                var amount: Double = 0
                transactions.forEach { transaction in
                    amount += transaction.amount
                }
                let date = Date()
                let calendar = Calendar.current
                let day = calendar.component(.day, from: date)
                guard let currentCurrency = currentCurrency,
                      let currencyRate = currencyRate else { return }
                if let addTransaction = addTransaction {
                    amount += addTransaction.amount
                }
                let progress = Progress(amount: abs(amount) / currencyRate,
                                        purpose: purpose,
                                        currentDay: day,
                                        currency: currentCurrency,
                                        currencyRate: currencyRate)
                input?.showProgress(progress)
            } catch {
                self.input?.showAlert(message: error.localizedDescription)
            }
        } else {
            totalAmount()
        }
    }
    
    private func prepareTransactionCellModel(_ transactions: [Transaction]) {
        let lastTransactionsCellModel: [TransactionCellModel] = transactions.compactMap { transaction in
            let category = try? categoryService.fetchCategory(for: transaction.category)
            guard let category = category,
                  let currency = currentCurrency,
                  let rate = currencyRate else { return nil }
            let isRevenue = (transaction.amount >= 0) ? true : false
            let amount = String(format: "%.2f", transaction.amount / rate) + currency.symbol
            return TransactionCellModel(category: category.title,
                                        image: category.image,
                                        amount: amount,
                                        date: dateFormatter.string(from: transaction.date),
                                        comment: transaction.comment,
                                        isRevenue: isRevenue)
        }
        input?.showLastTransactions(lastTransactionsCellModel)
    }

// MARK: - Selectors
    
    @objc private func reloadView(_ notification: NSNotification) {
        input?.showNotice("Транзакция добавлена")
        if let dictionary = notification.userInfo as? NSDictionary {
            if let transaction = dictionary["lastTransaction"] as? Transaction {
                lastTransaction.append(transaction)
                prepareTransactionCellModel(lastTransaction)
                guard var balance = balance else { return }
                balance += transaction.amount
                let total = String(format: "%.2f", balance)
                input?.showTotal(total)
                showProgress(transaction)
            }
        }
    }
    
    @objc private func updateCredential(_ notification: NSNotification) {
        if let uid = notification.userInfo?["uid"] as? String {
            userService.getUser(uid) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.input?.setUserName(user.login)
                case .failure(let error):
                    switch error {
                    case .isEmptyUser:
                        self?.input?.setUserName("Здравствуйте")
                    case .somethingError:
                        self?.input?.showAlert(message: error.localizedDescription)
                    }
                }
            }
        } else {
            input?.setUserName("Здравствуйте")
        }
    }
    
    @objc private func updateProgress() {
        showProgress()
    }
    
    @objc private func updateCurrency() {
        loadInformation()
    }
    
    @objc private func updateTransactions() {
        loadInformation()
    }
}

// MARK: - HomeOutput

extension HomePresenter: HomeOutput {
    func viewIsReady() {
        input?.showService(service)
        loadInformation()
    }
    
    func showService(at index: Int) {
        switch TypeService(rawValue: index) {
        case .chart:
            moduleOutput?.showChart()
        case .exchange:
            moduleOutput?.showExchangeRate()
        case .stocks:
            moduleOutput?.showStock()
        case .atm:
            moduleOutput?.showATM()
        case .news:
            moduleOutput?.showNews()
        case .none:
            break
        }
    }
}
