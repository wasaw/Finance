//
//  ProgressOutput.swift
//  Finance
//
//  Created by Александр Меренков on 13.11.2023.
//

import Foundation

protocol ProgressOutput: AnyObject {
    func viewIsReady()
    func saveExpense(_ expense: String)
    func setProgress(_ isOn: Bool)
}
