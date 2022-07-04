//
//  Model.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2022.
//

import Foundation

struct ChoiceService {
    let name: String
    let img: String
}
struct ChoiceTypeRevenue {
    let name: String
    let img: String
    var isChecked = false
}
struct ChoiceCategoryExpense {
    let name: String
    let img: String
    var isChecked = false
}
struct LastTransaction {
    var type: String
    var ammount: Int
    var comment: String
    var category: String
}
