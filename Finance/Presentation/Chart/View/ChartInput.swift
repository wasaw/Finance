//
//  ChartInput.swift
//  Finance
//
//  Created by Александр Меренков on 11.01.2024.
//

import Foundation
import DGCharts

protocol ChartInput: AnyObject {
    func showData(_ displayData: [ChartCell.DisplayData])
    func showPieData(_ displayData: PieChartDataSet)
    func showAlert(_ message: String)
    func setLoading(enable: Bool)
    func hideChart()
}
