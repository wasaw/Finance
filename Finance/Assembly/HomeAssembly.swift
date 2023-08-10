//
//  HomeAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class HomeAssembly {
    func makeHomeModule(homeCoordinator: HomePresenterOutput,
                        transactionsService: TransactionsServiceProtocol,
                        userService: UserServiceProtocol) -> UIViewController {
        let presenter = HomePresenter(homeCoordinator: homeCoordinator, transactionsService: transactionsService, userService: userService)
        let homeVC = HomeViewController(output: presenter)
        presenter.input = homeVC
        return homeVC
    }
}
