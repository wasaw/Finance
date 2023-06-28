//
//  StocksInput.swift
//  Finance
//
//  Created by Александр Меренков on 20.06.2023.
//

import Foundation

protocol StocksInput: AnyObject {
    func setLoading(enable: Bool)
    func setData(_ stockList: [Stock])
    func showAlert(with title: String, and text: String)
}
