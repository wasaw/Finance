//
//  AccountServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 26.12.2023.
//

import XCTest
@testable import Finance

final class AccountServiceTests: XCTestCase {
    
    var fileStore: FileStoreMock!
    var coreData: CoreDataServiceMock!
    var accountService: AccountServiceProtocol!
    
    override func setUp() {
        fileStore = FileStoreMock()
        coreData = CoreDataServiceMock()
        accountService = AccountService(fileStore: fileStore,
                                        coreData: coreData)
    }
    
    override func tearDown() {
        fileStore = nil
        coreData = nil
        accountService = nil
    }
    
    func testFetchAccounts() {
        let context = TestCoreDataStack().getMenagedObjectContext()
        let accountManagedObject = AccountManagedObject(usedContext: context)
        accountManagedObject.id = UUID()
        accountManagedObject.title = "title"
        accountManagedObject.amount = 1
        accountManagedObject.transactions = nil
        
        fileStore.stubbedGetImageResult = UIImage(named: "atm-machine")?.pngData()
        coreData.stubbedFetchAccountsResult = [accountManagedObject]
        
        accountService.fetchAccounts { result in
            switch result {
            case .success(let success):
                XCTAssertEqual(success[0].title, accountManagedObject.title)
            case .failure:
                XCTAssertThrowsError(true)
            }
        }
        
        XCTAssert(coreData.invokedFetchAccounts)
        XCTAssertEqual(coreData.invokedFetchAccountsCount, 1)
    }
    
    func testFetchAccount() {
        let id = UUID()
        let context = TestCoreDataStack().getMenagedObjectContext()
        let accountManagedObject = AccountManagedObject(usedContext: context)
        accountManagedObject.id = id
        accountManagedObject.amount = 1
        accountManagedObject.title = "title"
        accountManagedObject.transactions = nil
        
        fileStore.stubbedGetImageResult = UIImage(named: "atm-machine")?.pngData()
        coreData.stubbedFetchAccountsResult = ([accountManagedObject])
        
        do {
            let answer = try accountService.fetchAccount(for: id)
            XCTAssert(coreData.invokedFetchAccounts)
            XCTAssertEqual(answer.title, accountManagedObject.title)
        } catch {
            XCTAssertThrowsError(true)
        }
    }
}
