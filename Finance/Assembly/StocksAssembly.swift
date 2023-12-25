//
//  StocksAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class StocksAssembly {
    func makeStocksModule(stocksService: StocksServiceProtocol) -> UIViewController {
        let stockAdapter = StockAdapter()
        let presenter = StocksPresenter(stocksService: stocksService)
        let vc = StocksViewController(output: presenter, stockAdapter: stockAdapter)
        presenter.input = vc
        return vc
    }
}
