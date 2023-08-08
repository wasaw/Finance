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
    
    private let service = [ChoiceService(name: "Курс валют", img: "exchange-rate.png"),
                           ChoiceService(name: "Акции", img: "stock-market.png")]

    private var lastTransaction = [LastTransaction]()
//    private var lastTransaction = [LastTransaction]() {
//        didSet {
//            lastTransactionsCollectionView?.reloadData()
//        }
//    }
    
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(homeCoordinator: HomePresenterOutput,
         transactionsService: TransactionsServiceProtocol) {
        self.output = homeCoordinator
        self.transactionsService = transactionsService
        notification.addObserver(self, selector: #selector(reloadView), name: Notification.Name("AddTransaction"), object: nil)
    }
    
// MARK: - Helpers
    
    func loadInformation() {
        var revenue: Double = 0
        do {
            lastTransaction = try transactionsService.fetchTransactions()
        } catch {
            self.input?.showAlert(message: error.localizedDescription)
        }
        if !self.lastTransaction.isEmpty {
            self.input?.showLastTransaction()
            lastTransaction.forEach { transaction in
                revenue += transaction.amount
            }
        }
        if CurrencyRate.currentCurrency == .dollar {
            revenue /= CurrencyRate.usd
        }
        if CurrencyRate.currentCurrency == .euro {
            revenue /= CurrencyRate.eur
        }
        self.input?.showData(total: revenue,
                             currency: CurrencyRate.currentCurrency,
                             service: self.service,
                             lastTransaction: self.lastTransaction)
        
    }
    
// MARK: - Selectors
    
    @objc private func reloadView(_ notification: NSNotification) {
        if let dictionary = notification.userInfo as? NSDictionary {
            if let transaction = dictionary["lastTransaction"] as? LastTransaction {
                if lastTransaction.isEmpty {
                    input?.showLastTransaction()
                }
                lastTransaction.append(transaction)
                var revenue: Double = 0
                lastTransaction.forEach { transaction in
                    revenue += transaction.amount
                }
                input?.showData(total: revenue,
                                currency: CurrencyRate.currentCurrency,
                                service: self.service,
                                lastTransaction: lastTransaction)
            }
        }
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
}
