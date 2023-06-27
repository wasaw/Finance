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
    
    private let coreDataService: CoreDataProtocol
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
         coreDataService: CoreDataProtocol) {
        self.output = homeCoordinator
        self.coreDataService = coreDataService
    }
    
// MARK: - Helpers
    
    func loadInformation() {
        DispatchQueue.main.async {
            do {
                let transactionManagedObject = try self.coreDataService.fetchTransactions()
                var revenue: Double = 0
                self.lastTransaction = transactionManagedObject.compactMap { transaction in
                    guard let type = transaction.type,
                          let img = transaction.img,
                          let date = transaction.date,
                          let comment = transaction.comment,
                          let category = transaction.category
                    else {
                        return nil
                    }
                    revenue += transaction.amount
                    return LastTransaction(type: type,
                                           amount: transaction.amount,
                                           img: img,
                                           date: date,
                                           comment: comment,
                                           category: category)
                }
                if !self.lastTransaction.isEmpty {
                    self.input?.showLastTransaction()
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
            } catch {
                self.input?.showAlert(message: error.localizedDescription)
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
