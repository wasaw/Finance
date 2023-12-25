//
//  AddTransactionAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class AddTransactionAssembly {
    func makeAddTransactionModul(accountService: AccountServiceProtocol,
                                 categoryService: CategoryServiceProtocol,
                                 transactionsService: TransactionsServiceProtocol,
                                 fileStore: FileStoreProtocol) -> UIViewController {
        let accountAdapter = AccountAdaper()
        let categoryAdapter = CategoryAdapter()
        let presenter = AddTransactionPresenter(accountService: accountService,
                                                categoryService: categoryService,
                                                transactionsService: transactionsService,
                                                fileStore: fileStore)
        let vc = AddTransactionViewController(output: presenter,
                                              accountAdapter: accountAdapter,
                                              categoryAdapter: categoryAdapter)
        presenter.input = vc
        return vc
    }
}
