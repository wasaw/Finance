//
//  LastTransactionAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 24.08.2023.
//

import UIKit

final class LastTransactionAssembly {
    
// MARK: - Helpers
    
    func makeLastTransactionModule(_ transaction: LastTransaction) -> UIViewController {
        let presenter = LastTransactionPresenter(transaction: transaction)
        let viewController = LastTransactionViewController(output: presenter)
        presenter.input = viewController
        return viewController
    }
}
