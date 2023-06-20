//
//  HomeCoordinator.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import UIKit

final class HomeCoordinator {
    
// MARK: - Properties
    
    private var navigation: UINavigationController?
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let presenter = HomePresenter(output: self)
        let homeVC = HomeViewController(output: presenter)
        presenter.input = homeVC
        let nav = UINavigationController(rootViewController: homeVC)
        navigation = nav
        return nav
    }
}

// MARK: - HomePresenterOutput

extension HomeCoordinator: HomePresenterOutput {
    func showExchangeRate() {
        let vc = ExchangeRateViewController()
        navigation?.pushViewController(vc, animated: true)
    }
    
    func showStock() {
        let vc = StocksController()
        navigation?.pushViewController(vc, animated: true)
    }
}
