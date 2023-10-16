//
//  ATMPresenter.swift
//  Finance
//
//  Created by Александр Меренков on 16.10.2023.
//

import Foundation

final class ATMPresenter {
    
// MARK: - Properties
    
    weak var input: ATMInput?
}

// MARK: - ATMOutput

extension ATMPresenter: ATMOutput {
    func viewIsReady() {
    }
}
