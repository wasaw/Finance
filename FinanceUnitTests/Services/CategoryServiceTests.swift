//
//  CategoryServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 15.01.2024.
//

import XCTest
@testable import Finance

final class CategoryServiceTests: XCTestCase {
    
    var fileStore: FileStoreMock!
    var coreData: CoreDataServiceMock!
    var categoryService: CategoryServiceProtocol!
    
    override func setUp() {
        fileStore = FileStoreMock()
        coreData = CoreDataServiceMock()
        categoryService = CategoryService(fileStore: fileStore,
                                          coreData: coreData)
    }
    
    override func tearDown() {
        fileStore = nil
        coreData = nil
        categoryService = nil
    }
    
    func testFetchCategories() {
        let context = TestCoreDataStack().getMenagedObjectContext()
        let categoryManagedObject = CategoryManagedObject(usedContext: context)
        categoryManagedObject.id = UUID()
        categoryManagedObject.title = "title"
        categoryManagedObject.transactions = nil
        
        fileStore.stubbedGetImageResult = UIImage(named: "atm-machine")?.pngData()
        coreData.stubbedFetchCategoriesResult = [categoryManagedObject]
        
        categoryService.fetchCategories { result in
            switch result {
            case .success(let success):
                XCTAssertEqual(success[0].title, categoryManagedObject.title)
            case .failure:
                XCTAssertThrowsError(true)
            }
        }
        
        XCTAssert(coreData.invokedFetchCategories)
        XCTAssertEqual(coreData.invokedFetchCategoriesCount, 1)
    }
    
    func testFetchCategory() {
        let id = UUID()
        let context = TestCoreDataStack().getMenagedObjectContext()
        let categoryManagedObject = CategoryManagedObject(usedContext: context)
        categoryManagedObject.id = id
        categoryManagedObject.title = "title"
        categoryManagedObject.transactions = nil
        
        fileStore.stubbedGetImageResult = UIImage(named: "atm-machine")?.pngData()
        coreData.stubbedFetchCategoriesResult = [categoryManagedObject]
        
        do {
            let result = try categoryService.fetchCategory(for: id)
            XCTAssertEqual(result.title, categoryManagedObject.title)
        } catch {
            XCTAssertThrowsError(true)
        }
        
        XCTAssert(coreData.invokedFetchCategories)
        XCTAssertEqual(coreData.invokedFetchCategoriesCount, 1)
    }
    
    func testFetchCategoriesAmount() {
        let context = TestCoreDataStack().getMenagedObjectContext()
        let categoryManagedObject = CategoryManagedObject(usedContext: context)
        categoryManagedObject.id = UUID()
        categoryManagedObject.title = "title"
        categoryManagedObject.transactions = nil
        
        fileStore.stubbedGetImageResult = UIImage(named: "atm-machine")?.pngData()
        coreData.stubbedFetchCategoriesResult = [categoryManagedObject]
        
        categoryService.fetchCategoriesAmount { result in
            switch result {
            case .success(let success):
                XCTAssertEqual(success[0].title, categoryManagedObject.title)
            case .failure:
                XCTAssertThrowsError(true)
            }
        }
        
        XCTAssert(coreData.invokedFetchCategories)
        XCTAssertEqual(coreData.invokedFetchCategoriesCount, 1)
    }
}
