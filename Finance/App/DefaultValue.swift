//
//  DefaultValue.swift
//  Finance
//
//  Created by Александр Меренков on 26.06.2023.
//

import Foundation

final class DefaultValue {
    
// MARK: - setDefaultValue

private let revenue = [ChoiceTypeRevenue(name: "Зарплата", img: "calendar.png"),
               ChoiceTypeRevenue(name: "Продажа", img: "sales.png"),
               ChoiceTypeRevenue(name: "Проценты", img: "price-tag.png"),
               ChoiceTypeRevenue(name: "Наличные", img: "salary.png"),
               ChoiceTypeRevenue(name: "Вклад", img: "deposit.png"),
               ChoiceTypeRevenue(name: "Иное", img: "other.png")]

private let category = [ChoiceCategoryExpense(name: "Продукты", img: "products.png"),
                ChoiceCategoryExpense(name: "Транспорт", img: "transportation.png"),
                ChoiceCategoryExpense(name: "Образование", img: "education.png"),
                ChoiceCategoryExpense(name: "Подписки", img: "subscription.png"),
                ChoiceCategoryExpense(name: "Прочее", img: "other.png"),
                ChoiceCategoryExpense(name: "Связь", img: "chat.png"),
                ChoiceCategoryExpense(name: "Развлечения", img: "cinema.png"),
                ChoiceCategoryExpense(name: "Ресторан", img: "fast-food.png"),
                ChoiceCategoryExpense(name: "Здоровье", img: "healthcare.png")]

private let fileStore = FileStore()

    init() {
        fileStore.readAppInformation("revenue") { [weak self] (result: Result<[ChoiceTypeRevenue], FileManagerError>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                switch error {
                case .fileNotExists:
                    self?.fileStore.setAppInformation(filename: "revenue", file: self?.revenue)
                }
            }
        }
        
        fileStore.readAppInformation("category") { [weak self] (result: Result<[ChoiceCategoryExpense], FileManagerError>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                switch error {
                case .fileNotExists:
                    self?.fileStore.setAppInformation(filename: "category", file: self?.category)
                }
            }
        }
    }
}
