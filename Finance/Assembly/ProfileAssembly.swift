//
//  ProfileAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class ProfileAssembly {
    func makeProfileModule(profileCoordinator: ProfilePresenterOutput) -> UIViewController {
        let presenter = ProfilePresenter(output: profileCoordinator)
        let vc = ProfileViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
