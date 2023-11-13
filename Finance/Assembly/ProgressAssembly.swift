//
//  ProgressAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 13.11.2023.
//

import UIKit

final class ProgressAssembly {
    func makeProgressModule(output: ProfilePresenterOutput) -> UIViewController {
        let presenter = ProgressPresenter(output: output)
        let view = ProgressViewController(output: presenter)
        presenter.input = view
        return view
    }
}
