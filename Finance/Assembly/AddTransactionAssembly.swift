//
//  AddTransactionAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class AddTransactionAssembly {
    func makeAddTransactionModul(transactionsService: TransactionsServiceProtocol) -> UIViewController {
        let presenter = AddTransactionPresenter(transactionsService: transactionsService)
        let vc = AddTransactionViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
