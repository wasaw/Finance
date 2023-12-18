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
    private let accounts: [String]
    private let accountsImages: [String]
    private let categories: [String]
    private let categoriesImages: [String]
    
// MARK: - Lifecycle
    
    init(fileStore: FileStoreProtocol, coreData: CoreDataServiceProtocol) {
        self.fileStore = fileStore
        self.coreData = coreData
        
        accounts = ["Зарплата",
                    "Продажа",
                    "Проценты",
                    "Наличные",
                    "Вклад",
                    "Иное"]
        accountsImages = ["calendar.png",
                          "sales.png",
                          "price-tag.png",
                          "salary.png",
                          "deposit.png",
                          "other.png"]
        
        categories = ["Продукты",
                      "Транспорт",
                      "Образование",
                      "Подписки",
                      "Прочее",
                      "Связь",
                      "Развлечения",
                      "Ресторан",
                      "Здоровье"]
        categoriesImages = ["products.png",
                            "transportation.png",
                            "education.png",
                            "subscription.png",
                            "other.png",
                            "chat.png",
                            "cinema.png",
                            "fast-food.png",
                            "healthcare.png"]
    }
    
}

// MARK: - DefaultValueServiceProtocol

extension DefaultValueService: DefaultValueServiceProtocol {
    func saveValue() {
        for (index, account) in accounts.enumerated() {
            let id = UUID()
            coreData.save { context in
                let accountManagedObject = AccountManagedObject(context: context)
                accountManagedObject.id = id
                accountManagedObject.title = account
                accountManagedObject.amount = 0
            }
            guard let imageData = UIImage(named: accountsImages[index])?.pngData() else { return }
            fileStore.saveImage(data: imageData, with: id.uuidString) { result in
                switch result {
                case .success:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        for (index, category) in categories.enumerated() {
            let id = UUID()
            coreData.save { context in
                let categoryManagedObject = CategoryManagedObject(context: context)
                categoryManagedObject.id = id
                categoryManagedObject.title = category
            }
            guard let imageData = UIImage(named: categoriesImages[index])?.pngData() else { return }
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
