//
//  AuthAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class AuthAssembly {
    func makeAuthModul(authService: AuthServiceProtocol) -> UIViewController {
        let presenter = AuthPresenter(authService: authService)
        let vc = AuthViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
