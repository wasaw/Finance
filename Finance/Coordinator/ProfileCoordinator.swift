//
//  ProfileCoordinator.swift
//  Finance
//
//  Created by Александр Меренков on 21.06.2023.
//

import UIKit

final class ProfileCoordinator {
    
// MARK: - Properties
    
    private var navigation: UINavigationController?
    
// MARK: - Helpers
    
    func start() -> UINavigationController {
        let presenter = ProfilePresenter()
        let vc = ProfileViewController(output: presenter)
        presenter.input = vc
        let nav = UINavigationController(rootViewController: vc)
        navigation = nav
        return nav
    }
}
