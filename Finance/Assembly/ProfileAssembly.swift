//
//  ProfileAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class ProfileAssembly {
    func makeProfileModule(profileCoordinator: ProfilePresenterOutput, coreData: CoreDataServiceProtocol) -> UIViewController {
        let presenter = ProfilePresenter(output: profileCoordinator)
        let vc = ProfileViewController(output: presenter, coreData: coreData)
        presenter.input = vc
        return vc
    }
}
