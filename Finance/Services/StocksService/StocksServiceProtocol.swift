//
//  StocksServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 15.08.2023.
//

import Foundation

protocol StocksServiceProtocol: AnyObject {
    func getStocks(completion: @escaping ((Result<[Stock], Error>) -> Void))
}
