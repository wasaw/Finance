//
//  AuthAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class AuthAssembly {
    func makeAuthModul(authCoordinator: AuthPresenterOutput) -> UIViewController {
        let presenter = AuthPresenter(output: authCoordinator)
        let vc = AuthViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
