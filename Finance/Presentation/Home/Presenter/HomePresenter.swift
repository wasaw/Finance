//
//  HomePresenter.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2023.
//

import UIKit

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
    private let output: HomePresenterOutput
    private let transactionsService: TransactionsServiceProtocol
    private let categoryService: CategoryServiceProtocol
    private let userService: UserServiceProtocol
    
    private let service = [ChoiceService(name: "Курс валют", img: "exchange-rate.png", type: .exchange),
                           ChoiceService(name: "Акции", img: "stock-market.png", type: .stocks),
                           ChoiceService(name: "Банкоматы", img: "atm-machine", type: .atm),
                           ChoiceService(name: "Новости", img: "newspaper", type: .news)]

    private var lastTransaction = [Transaction]()
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yyyy"
        return df
    }()
    
    private let notification = NotificationCenter.default
    private let userDefaults = UserDefaults.standard
    
// MARK: - Lifecycle
    
    init(homeCoordinator: HomePresenterOutput,
         transactionsService: TransactionsServiceProtocol,
         categoryService: CategoryServiceProtocol,
         userService: UserServiceProtocol) {
        self.output = homeCoordinator
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
        if let uid = userDefaults.value(forKey: "uid") as? String {
            userService.getUser(uid) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.input?.setUserName(user.login)
                case .failure:
                    self?.input?.setUserName("Здравствуйте")
                }
            }
        }
        do {
            lastTransaction = try transactionsService.fetchTransactions(limit: 5)
            let lastTransactionsCellModel: [TransactionCellModel] = lastTransaction.compactMap { transaction in
                let category = try? categoryService.fetchCategory(for: transaction.category)
                guard let category = category else { return nil }
                let isRevenue = (transaction.amount >= 0) ? true : false
                return TransactionCellModel(category: category.title,
                                            image: category.image,
                                            amount: String(format: "%.2f", transaction.amount),
                                            date: dateFormatter.string(from: transaction.date),
                                            comment: transaction.comment,
                                            isRevenue: isRevenue)
            }
            input?.showLastTransactions(lastTransactionsCellModel)
        } catch {
            self.input?.showAlert(message: error.localizedDescription)
        }
        showRevenue()
        showProgress()
    }
    
    private func showRevenue() {
        guard let currencyRate = userDefaults.value(forKey: "currencyRate") as? Double,
              let currency = userDefaults.value(forKey: "currency") as? Int,
              let currentCurrency = Currency(rawValue: currency) else { return }
        var revenue: Double = 0
        if !self.lastTransaction.isEmpty {
            self.input?.showLastTransaction()
            revenue = lastTransaction.reduce(0) { $0 + $1.amount }
        }
        
        revenue /= currencyRate
        let total = String(format: "%.2f", revenue) + currentCurrency.getMark()
        self.input?.showData(total: total,
                             service: self.service,
                             lastTransaction: self.lastTransaction)
    }
    
    private func showProgress() {
        let isProgress = userDefaults.value(forKey: "isProgress") as? Bool
        if isProgress == true,
           let currencyRate = userDefaults.value(forKey: "currencyRate") as? Double,
           let currency = userDefaults.value(forKey: "currency") as? Int,
           let currentCurrency = Currency(rawValue: currency),
           let purpose = userDefaults.value(forKey: "expenseLimit") as? Double {
            do {
                let transactions = try transactionsService.fetchTransactionByMonth()
                var amount: Double = 0
                transactions.forEach { transaction in
                    amount += transaction.amount
                }
                let date = Date()
                let calendar = Calendar.current
                let day = calendar.component(.day, from: date)
                let progress = Progress(amount: -amount,
                                        purpose: purpose,
                                        currentDay: day,
                                        currency: currentCurrency,
                                        currencyRate: currencyRate)
                input?.showProgress(progress)
            } catch {
                self.input?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
// MARK: - Selectors
    
    @objc private func reloadView(_ notification: NSNotification) {
        if let dictionary = notification.userInfo as? NSDictionary {
            if let transaction = dictionary["lastTransaction"] as? Transaction {
                lastTransaction.append(transaction)
                showRevenue()
            }
            showProgress()
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
        loadInformation()
    }
    
    func showService(at index: Int) {
        switch TypeService(rawValue: index) {
        case .exchange:
            output.showExchangeRate()
        case .stocks:
            output.showStock()
        case .atm:
            output.showATM()
        case .news:
            output.showNews()
        case .none:
            break
        }
    }
    
    func showTransaction(for index: Int) {
        output.showLastTransaction(lastTransaction[index])
    }
}
