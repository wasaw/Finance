//
//  ExchangeRateAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class ExchangeRateAssembly {
    func makeExchangeRateModule(network: NetworkProtocol,
                                config: NetworkConfiguration,
                                coreData: CoreDataProtocol) -> UIViewController {
        let presenter = ExchangeRatePresenter(network: network,
                                              config: config,
                                              coreDataService: coreData)
        let vc = ExchangeRateViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
