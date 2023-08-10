//
//  ProfileAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class ProfileAssembly {
    func makeProfileModule(authService: AuthServiceProtocol, userService: UserServiceProtocol) -> UIViewController {
        let presenter = ProfilePresenter(authService: authService, userService: userService)
        let vc = ProfileViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
