//
//  ExchangeRateOutput.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import Foundation

protocol ExchangeRateOutput: AnyObject {
    func viewIsReady()
    func loadCurrency(_ requestCurrency: String)
}
