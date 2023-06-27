//
//  HomeAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class HomeAssembly {
    func makeHomeModule(homeCoordinator: HomePresenterOutput, coreDataService: CoreDataProtocol) -> UIViewController {
        let presenter = HomePresenter(homeCoordinator: homeCoordinator, coreDataService: coreDataService)
        let homeVC = HomeViewController(output: presenter)
        presenter.input = homeVC
        return homeVC
    }
}
