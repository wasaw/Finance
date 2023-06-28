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
    
// MARK: - Lifecycle
    
    init(homeCoordinator: HomePresenterOutput,
         transactionsService: TransactionsServiceProtocol) {
        self.output = homeCoordinator
        self.transactionsService = transactionsService
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
