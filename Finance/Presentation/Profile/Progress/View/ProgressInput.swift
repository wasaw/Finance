//
//  ProgressInput.swift
//  Finance
//
//  Created by Александр Меренков on 13.11.2023.
//

import Foundation

protocol ProgressInput: AnyObject {
    func setProgressItem(_ item: ProgressItem)
}
