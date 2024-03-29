//
//  ChartAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 11.01.2024.
//

import UIKit

final class ChartAssembly {
    func makeChartModule(moduleOutput: ChartPresenterOutput, categoryService: CategoryServiceProtocol) -> UIViewController {
        let presenter = ChartPresenter(moduleOutput: moduleOutput, categoryService: categoryService)
        let view = ChartViewController(output: presenter)
        presenter.input = view
        return view
    }
}
