//
//  ChartPresenterOutput.swift
//  Finance
//
//  Created by Александр Меренков on 16.01.2024.
//

import Foundation

protocol ChartPresenterOutput: AnyObject {
    func showAllTransactions(for id: UUID)
}
