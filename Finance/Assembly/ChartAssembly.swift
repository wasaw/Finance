//
//  ChartAssembly.swift
//  Finance
//
//  Created by Александр Меренков on 11.01.2024.
//

import UIKit

final class ChartAssembly {
    func makeChartModule() -> UIViewController {
        let presenter = ChartPresenter()
        let view = ChartViewController(output: presenter)
        presenter.input = view
        return view
    }
}
