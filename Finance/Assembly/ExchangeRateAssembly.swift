//
//  ExchangeRateAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class ExchangeRateAssembly {
    func makeExchangeRateModule() -> UIViewController {
        let presenter = ExchangeRatePresenter()
        let vc = ExchangeRateViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
