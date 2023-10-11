//
//  HomePresenter.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2023.
//

import UIKit

final class HomePresenter {
    
// MARK: - Properties
    
    weak var input: HomeInput?
    private let output: HomePresenterOutput
    private let transactionsService: TransactionsServiceProtocol
    private let userService: UserServiceProtocol
    
    private let service = [ChoiceService(name: "Курс валют", img: "exchange-rate.png"),
                           ChoiceService(name: "Акции", img: "stock-market.png")]

    private var lastTransaction = [Transaction]()
    
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(homeCoordinator: HomePresenterOutput,
         transactionsService: TransactionsServiceProtocol,
         userService: UserServiceProtocol) {
        self.output = homeCoordinator
        self.transactionsService = transactionsService
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
    }
    
    private func loadInformation() {
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            userService.getUser(uid) { [weak self] result in
                switch result {
                case .success(let user):
                    self?.input?.setUserName(user.login)
                case .failure:
                    self?.input?.setUserName("Здравствуйте")
                }
            }
        }
        guard let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double,
              let currency = UserDefaults.standard.value(forKey: "currency") as? Int,
              let currentCurrency = Currency(rawValue: currency) else { return }
        var revenue: Double = 0
        do {
            lastTransaction = try transactionsService.fetchTransactions()
        } catch {
            self.input?.showAlert(message: error.localizedDescription)
        }
        if !self.lastTransaction.isEmpty {
            self.input?.showLastTransaction()
            for index in 0..<lastTransaction.count {
                revenue += lastTransaction[index].amount
            }
        }
        
        revenue /= currencyRate
        let total = String(format: "%.2f", revenue) + currentCurrency.getMark()
        self.input?.showData(total: total,
//                             currency: currentCurrency,
                             service: self.service,
                             lastTransaction: self.lastTransaction)
        
    }
    
// MARK: - Selectors
    
    @objc private func reloadView(_ notification: NSNotification) {
        if let dictionary = notification.userInfo as? NSDictionary {
            if let transaction = dictionary["lastTransaction"] as? Transaction {
                if lastTransaction.isEmpty {
                    input?.showLastTransaction()
                }
                lastTransaction.append(transaction)
                var revenue: Double = 0
                lastTransaction.forEach { transaction in
                    revenue += transaction.amount
                }
                guard let currencyRate = UserDefaults.standard.value(forKey: "currencyRate") as? Double,
                      let currency = UserDefaults.standard.value(forKey: "currency") as? Int,
                      let currentCurrency = Currency(rawValue: currency) else { return }
                revenue /= currencyRate
                let total = String(format: "%.2f", revenue) + currentCurrency.getMark()
                input?.showData(total: total,
                                service: self.service,
                                lastTransaction: lastTransaction)
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
        }
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
        if index == 0 {
            output.showExchangeRate()
        } else {
            output.showStock()
        }
    }
    
    func showTransaction(for index: Int) {
        output.showLastTransaction(lastTransaction[index])
    }
}
