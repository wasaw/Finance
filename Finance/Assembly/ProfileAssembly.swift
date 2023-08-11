//
//  ProfileAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class ProfileAssembly {
    func makeProfileModule(output: ProfilePresenterOutput, authService: AuthServiceProtocol, userService: UserServiceProtocol) -> UIViewController {
        let presenter = ProfilePresenter(output: output, authService: authService, userService: userService)
        let vc = ProfileViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
