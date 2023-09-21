//
//  ProfileAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class ProfileAssembly {
    func makeProfileModule(output: ProfilePresenterOutput,
                           authService: AuthServiceProtocol,
                           userService: UserServiceProtocol,
                           exchageRateService: ExchangeRateServiceProtocol,
                           transactionsService: TransactionsServiceProtocol) -> UIViewController {
        let presenter = ProfilePresenter(output: output,
                                         authService: authService,
                                         userService: userService,
                                         exchangeRateService: exchageRateService,
                                         transactionsService: transactionsService)
        let vc = ProfileViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
