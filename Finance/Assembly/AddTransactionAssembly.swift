//
//  AddTransactionAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class AddTransactionAssembly {
    func makeAddTransactionModul(accountService: AccountServiceProtocol,
                                 transactionsService: TransactionsServiceProtocol,
                                 defaultValueService: DefaultValueServiceProtocol,
                                 fileStore: FileStoreProtocol) -> UIViewController {
        let presenter = AddTransactionPresenter(accountService: accountService,
                                                transactionsService: transactionsService,
                                                defaultValueService: defaultValueService,
                                                fileStore: fileStore)
        let vc = AddTransactionViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
