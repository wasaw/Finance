//
//  ExchangeRateAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class ExchangeRateAssembly {
    func makeExchangeRateModule(coreData: CoreDataServiceProtocol,
                                exchangeRateService: ExchangeRateServiceProtocol) -> UIViewController {
        let listCurrencyAdapter = ListCurrencyAdapter()
        let presenter = ExchangeRatePresenter(coreDataService: coreData,
                                              exchangeRateService: exchangeRateService)
        let vc = ExchangeRateViewController(output: presenter, listCurrencyAdapter: listCurrencyAdapter)
        presenter.input = vc
        return vc
    }
}
