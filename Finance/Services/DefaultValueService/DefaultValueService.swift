//
//  DefaultValueService.swift
//  Finance
//
//  Created by Александр Меренков on 28.06.2023.
//

import UIKit

final class DefaultValueService {
    
// MARK: - Properties
    
    private let fileStore: FileStoreProtocol
    private let coreData: CoreDataServiceProtocol
    private let accounts: [ChoiceTypeRevenue]
    private let categories: [ChoiceCategoryExpense]
    
// MARK: - Lifecycle
    
    init(fileStore: FileStoreProtocol, coreData: CoreDataServiceProtocol) {
        self.fileStore = fileStore
        self.coreData = coreData
        
        accounts = [ChoiceTypeRevenue(name: "Зарплата", img: "calendar.png"),
                   ChoiceTypeRevenue(name: "Продажа", img: "sales.png"),
                   ChoiceTypeRevenue(name: "Проценты", img: "price-tag.png"),
                   ChoiceTypeRevenue(name: "Наличные", img: "salary.png"),
                   ChoiceTypeRevenue(name: "Вклад", img: "deposit.png"),
                   ChoiceTypeRevenue(name: "Иное", img: "other.png")]
        
        categories = [ChoiceCategoryExpense(name: "Продукты", img: "products.png"),
                    ChoiceCategoryExpense(name: "Транспорт", img: "transportation.png"),
                    ChoiceCategoryExpense(name: "Образование", img: "education.png"),
                    ChoiceCategoryExpense(name: "Подписки", img: "subscription.png"),
                    ChoiceCategoryExpense(name: "Прочее", img: "other.png"),
                    ChoiceCategoryExpense(name: "Связь", img: "chat.png"),
                    ChoiceCategoryExpense(name: "Развлечения", img: "cinema.png"),
                    ChoiceCategoryExpense(name: "Ресторан", img: "fast-food.png"),
                    ChoiceCategoryExpense(name: "Здоровье", img: "healthcare.png")]
    }
    
}

// MARK: - DefaultValueServiceProtocol

extension DefaultValueService: DefaultValueServiceProtocol {
    func saveValue() {
        accounts.forEach { account in
            let id = UUID()
            coreData.save { context in
                let accountManagedObject = AccountManagedObject(context: context)
                accountManagedObject.id = id
                accountManagedObject.title = account.name
                accountManagedObject.amount = 0
            }
            guard let imageData = UIImage(named: account.img)?.pngData() else { return }
            fileStore.saveImage(data: imageData, with: id.uuidString) { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        categories.forEach { category in
            let id = UUID()
            coreData.save { context in
                let categoryManagedObject = CategoryManagedObject(context: context)
                categoryManagedObject.id = id
                categoryManagedObject.title = category.name
            }
            guard let imageData = UIImage(named: category.img)?.pngData() else { return }
            fileStore.saveImage(data: imageData, with: id.uuidString) { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchValue() throws -> ([ChoiceCategoryExpense], [ChoiceTypeRevenue]) {
        var category = [ChoiceCategoryExpense]()
        var revenue = [ChoiceTypeRevenue]()
        
        fileStore.readAppInformation("category") { (result: Result<[ChoiceCategoryExpense], FileManagerError>) in
            switch result {
            case .success(let answer):
                category = answer
            case .failure:
                category = []
            }
        }
        
        fileStore.readAppInformation("revenue") { (result: Result<[ChoiceTypeRevenue], FileManagerError>) in
            switch result {
            case .success(let answer):
                revenue = answer
            case .failure:
                revenue = []
            }
        }
        
        return (category, revenue)
    }
    
    func fetchStocks() -> [Stock] {
        var stocks = [Stock]()
        fileStore.readAppInformation("stocks") { (result: Result<[Stock], FileManagerError>) in
            switch result {
            case .success(let answer):
                stocks = answer
            case .failure:
                stocks = []
            }
        }
        return stocks
    }
    
    func fetchExchangeValue() -> ([String], [String]) {
        var fullName = [String]()
        var img = [String]()
        
        fileStore.readAppInformation("exchangeFullName") { (result: Result<[String], FileManagerError>) in
            switch result {
            case .success(let answer):
                fullName = answer
            case .failure:
                fullName = []
            }
        }
        
        fileStore.readAppInformation("exchangeImg") { (result: Result<[String], FileManagerError>)  in
            switch result {
            case .success(let answer):
                img = answer
            case .failure:
                img = []
            }
        }
        return (fullName, img)
    }
}
