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
    
    private let service = [ChoiceService(name: "Курс валют", img: "exchange-rate.png", type: .exchange),
                           ChoiceService(name: "Акции", img: "stock-market.png", type: .stocks),
                           ChoiceService(name: "Банкоматы", img: "atm-machine", type: .atm),
                           ChoiceService(name: "Новости", img: "newspaper", type: .news)]

    private var lastTransaction = [Transaction]()
    
    private let notification = NotificationCenter.default
    private let userDefaults = UserDefaults.standard
    
// MARK: - Lifecycle
    
    init(homeCoordinator: HomePresenterOutput,
         transactionsService: TransactionsServiceProtocol,
         userService: UserServiceProtocol) {
        self.output = homeCoordinator
        self.transactionsService = transactionsService
        self.userService = userService
        registerNotification()
        userDefaults.set(true, forKey: "isProgress")
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
            lastTransaction = try transactionsService.fetchTransactions()
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
        if userDefaults.value(forKey: "isProgress") != nil {
            do {
                let transactions = try transactionsService.fetchTransactionByMonth()
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
