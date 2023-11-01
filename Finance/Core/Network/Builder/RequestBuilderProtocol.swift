//
//  RequestBuilderProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 01.11.2023.
//

import Foundation

protocol RequestBuilderProtocol: AnyObject {
    func getExchangeRequest(_ requestCurrency: String) throws -> URLRequest
    func getStocksRequest(date: String?) throws -> URLRequest
    func getNewsRequest(page: Int) throws -> URLRequest
}
