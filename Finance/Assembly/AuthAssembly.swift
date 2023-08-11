//
//  AuthAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class AuthAssembly {
    func makeAuthModul(output: AuthPresenterOutput, authService: AuthServiceProtocol) -> UIViewController {
        let presenter = AuthPresenter(output: output, authService: authService)
        let vc = AuthViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
