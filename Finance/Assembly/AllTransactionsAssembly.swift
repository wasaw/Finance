//
//  AllTransactionsAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 16.01.2024.
//

import UIKit

final class AllTransactionsAssembly {
    func makeAllTransactionsModule(for id: UUID) -> UIViewController {
        let presenter = AllTransactionsPresenter(id: id)
        let vc = AllTransactionsViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
