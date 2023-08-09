//
//  ProfileAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class ProfileAssembly {
    func makeProfileModule(coreData: CoreDataServiceProtocol,
                           authService: AuthServiceProtocol) -> UIViewController {
        let presenter = ProfilePresenter(authService: authService)
        let vc = ProfileViewController(output: presenter, coreData: coreData)
        presenter.input = vc
        return vc
    }
}
