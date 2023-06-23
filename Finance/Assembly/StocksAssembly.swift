//
//  StocksAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class StocksAssembly {
    func makeStocksModule(network: NetworkProtocol, config: NetworkConfiguration) -> UIViewController {
        let presenter = StocksPresenter(network: network, config: config)
        let vc = StocksViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
