//
//  TransactionsServiceTest.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 04.08.2023.
//

import XCTest
@testable import Finance

final class TransactionsServiceTest: XCTestCase {
    
    var coreData: CoreDataServiceMock!
    var accountService: AccountServiceProtocol!
    var categoryService: CategoryServiceProtocol!
    var firebaseService: FirebaseServiceMock!
    var transactionsService: TransactionsServiceProtocol!
    
    override func setUp() {
        coreData = CoreDataServiceMock()
        firebaseService = FirebaseServiceMock()
        accountService = AccountServiceMock()
        categoryService = CategoryServiceMock()
        transactionsService = TransactionsService(coreData: coreData,
                                                  firebaseService: firebaseService,
                                                  accountService: accountService,
                                                  categoryService: categoryService)
    }
    
    override func tearDown() {
        coreData = nil
        firebaseService = nil
        accountService = nil
        categoryService = nil
        transactionsService = nil
    }
    
    func testFetchTransactions() throws {
        let context = TestCoreDataStack().getMenagedObjectContext()
        let account = AccountManagedObject(usedContext: context)
        account.amount = 2
        account.title = ""
        account.id = UUID()
        let category = CategoryManagedObject(usedContext: context)
        category.id = UUID()
        category.title = ""
        let transactionsManagedObject = TransactionManagedObject(usedContext: context)
        transactionsManagedObject.amount = 2
        transactionsManagedObject.comment = "Пусто"
        transactionsManagedObject.date = Date(timeIntervalSince1970: 2000)
        transactionsManagedObject.account = account
        transactionsManagedObject.category = category
        
        coreData.stubbedFetchTransactionsResult = ([transactionsManagedObject])

        do {
            let answer = try transactionsService.fetchTransactions(limit: 1)
            XCTAssertEqual(coreData.invokedFetchTransactions, true)
            XCTAssertEqual(answer[0].comment, transactionsManagedObject.comment)
        } catch {
            XCTAssertThrowsError(true)
        }
    }
    
    func testFetchAmountBy() {
        let context = TestCoreDataStack().getMenagedObjectContext()
        let transactionsManagedObject = TransactionManagedObject(usedContext: context)
        transactionsManagedObject.amount = 332
        transactionsManagedObject.comment = "Пусто"
        transactionsManagedObject.date = Date(timeIntervalSince1970: 1230)
        
        let transactionsManagedObjectOther = TransactionManagedObject(usedContext: context)
        transactionsManagedObjectOther.amount = 107
        transactionsManagedObjectOther.comment = "Добавлено"
        transactionsManagedObjectOther.date = Date(timeIntervalSince1970: 1250)
        
        let checkResult = transactionsManagedObject.amount + transactionsManagedObjectOther.amount
        
        coreData.stubbedFetchTransactionsByRevenueResult = ([transactionsManagedObject, transactionsManagedObjectOther])
        
        do {
            let answer = try transactionsService.fetchAmountBy("Зарплата")
            XCTAssertEqual(coreData.invokedFetchTransactionsByRevenue, true)
            XCTAssertEqual(answer, checkResult)
        } catch {
            XCTAssertThrowsError(true)
        }
    }
    
    func testSaveTransaction() {
        let lastTransaction = Transaction(account: UUID(),
                                          category: UUID(),
                                          amount: 2,
                                          date: Date(timeIntervalSince1970: 2000),
                                          comment: "Пусто")
        
        transactionsService.saveTransaction(lastTransaction)
        
        XCTAssertEqual(coreData.invokedSave, true)
        XCTAssertEqual(coreData.invokedSaveCount, 1)
    }
}
