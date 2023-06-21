//
//  AddTransactionCoordinator.swift
//  Finance
//
//  Created by Александр Меренков on 21.06.2023.
//

import UIKit

final class AddTransactionCoordinator {
    
// MARK: - Helpers
    
    func start() -> UIViewController {
        let presenter = AddTransactionPresenter()
        let vc = AddTransactionViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
