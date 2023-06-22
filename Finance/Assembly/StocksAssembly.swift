//
//  StocksAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class StocksAssembly {
    func makeStocksModule() -> UIViewController {
        let presenter = StocksPresenter()
        let vc = StocksViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
