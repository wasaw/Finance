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
    
    private let databaseService = DatabaseService.shared
    private let networkService = NetworkService.shared
    private let service = [ChoiceService(name: "Курс валют", img: "exchange-rate.png", vc: ExchangeRateController()),
                           ChoiceService(name: "Акции", img: "stock-market.png", vc: StocksController())]

    private var lastTransaction = [LastTransaction]()
//    private var lastTransaction = [LastTransaction]() {
//        didSet {
//            lastTransactionsCollectionView?.reloadData()
//        }
//    }
    
// MARK: - Lifecycle
    
    init(output: HomePresenterOutput) {
        self.output = output
    }
    
// MARK: - Helpers
    
    func loadInformation() {
        DispatchQueue.main.async {
            self.databaseService.getTransactionInformation { result in
                switch result {
                case .success(let lastTransaction):
                    self.lastTransaction = lastTransaction
                    if !self.lastTransaction.isEmpty {
//                        self.lastTransactionsCollectionView?.isHidden = false
                        self.input?.showLastTransaction()
                    }
                    self.databaseService.getTypeInformation { result in
                        switch result {
                        case .success(let revenue):
                            let revenueArray = revenue
                            var revenue: Double = 0
                            for item in revenueArray {
                                revenue += item.amount
                            }
                            if CurrencyRate.currentCurrency == .dollar {
                                revenue /= CurrencyRate.usd
                            }
                            if CurrencyRate.currentCurrency == .euro {
                                revenue /= CurrencyRate.eur
                            }
//                            self.totalAccountView.setAccountLabel(total: revenue, currency: CurrencyRate.currentCurrency)
                            self.input?.showData(total: revenue,
                                                 currency: CurrencyRate.currentCurrency,
                                                 service: self.service,
                                                 lastTransaction: lastTransaction)
                        case .failure(let error):
                            self.input?.showAlert(message: error.localizedDescription)
//                            self.alert(with: "Ошибка", massage: error.localizedDescription)
                        }
                    }
                case .failure(let error):
                    self.input?.showAlert(message: error.localizedDescription)
//                    self.alert(with: "Ошибка", massage: error.localizedDescription)
                }
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
