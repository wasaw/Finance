//
//  DefaultValueServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 28.06.2023.
//

import Foundation

protocol DefaultValueServiceProtocol: AnyObject {
    func fetchValue() throws -> ([ChoiceCategoryExpense], [ChoiceTypeRevenue])
}
