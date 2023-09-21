//
//  AuthAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class AuthAssembly {
    func makeAuthModul(output: AuthPresenterOutput,
                       authService: AuthServiceProtocol,
                       transactionsService: TransactionsServiceProtocol) -> UIViewController {
        let presenter = AuthPresenter(output: output,
                                      authService: authService,
                                      transactionsService: transactionsService)
        let vc = AuthViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
