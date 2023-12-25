//
//  HomeAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class HomeAssembly {
    func makeHomeModule(homeCoordinator: HomePresenterOutput,
                        accountService: AccountServiceProtocol,
                        transactionsService: TransactionsServiceProtocol,
                        categoryService: CategoryServiceProtocol,
                        userService: UserServiceProtocol) -> UIViewController {
        let serviceAdapter = ServiceAdapter()
        let lastTransactionsAdapter = LastTransactionsAdapter()
        let presenter = HomePresenter(homeCoordinator: homeCoordinator,
                                      accountService: accountService,
                                      transactionsService: transactionsService,
                                      categoryService: categoryService,
                                      userService: userService)
        let homeVC = HomeViewController(output: presenter,
                                        serviceAdapter: serviceAdapter,
                                        lastTransactionsAdapter: lastTransactionsAdapter)
        presenter.input = homeVC
        return homeVC
    }
}
