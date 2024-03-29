//
//  HomePresenterOutput.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import Foundation

protocol HomePresenterOutput: AnyObject {
    func showChart()
    func showExchangeRate()
    func showStock()
    func showATM()
    func showNews()
}
