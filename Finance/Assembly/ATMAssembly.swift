//
//  ATMAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 16.10.2023.
//

import UIKit

final class ATMAssembly {
    func makeATMModule() -> UIViewController {
        let presenter = ATMPresenter()
        let vc = ATMViewController(output: presenter)
        presenter.input = vc
        return vc
    }
}
