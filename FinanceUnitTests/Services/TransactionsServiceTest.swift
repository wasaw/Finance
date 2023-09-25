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
    var transactionsService: TransactionsServiceProtocol!
    var firebaseService: FirebaseServiceProtocol!
    
    override func setUp() {
        coreData = CoreDataServiceMock()
        firebaseService = FirebaseServiceMock()
        transactionsService = TransactionsService(coreData: coreData, firebaseService: firebaseService)
    }
    
    override func tearDown() {
        coreData = nil
        transactionsService = nil
        firebaseService = nil
    }
    
    func testFetchTransactions() throws {
        let context = TestCoreDataStack().getMenagedObjectContext()
        let transactionsManagedObject = TransactionManagedObject(usedContext: context)
        transactionsManagedObject.category = "Новая"
        transactionsManagedObject.amount = 2
        transactionsManagedObject.comment = "Пусто"
        transactionsManagedObject.date = Date(timeIntervalSince1970: 2000)
        transactionsManagedObject.img = "house.fill"
        transactionsManagedObject.type = "Доход"
        
        coreData.stubbedFetchTransactionsResult = ([transactionsManagedObject])

        do {
            let answer = try transactionsService.fetchTransactions()
            XCTAssertEqual(coreData.invokedFetchTransactions, true)
            XCTAssertEqual(answer[0].category, transactionsManagedObject.category)
        } catch {
            XCTAssertThrowsError(true)
        }
    }
    
    func testFetchAmountBy() {
        let context = TestCoreDataStack().getMenagedObjectContext()
        let transactionsManagedObject = TransactionManagedObject(usedContext: context)
        transactionsManagedObject.category = "Зарплата"
        transactionsManagedObject.amount = 332
        transactionsManagedObject.comment = "Пусто"
        transactionsManagedObject.date = Date(timeIntervalSince1970: 1230)
        transactionsManagedObject.img = "house.fill"
        transactionsManagedObject.type = "Доход"
        
        let transactionsManagedObjectOther = TransactionManagedObject(usedContext: context)
        transactionsManagedObjectOther.category = "Зарплата"
        transactionsManagedObjectOther.amount = 107
        transactionsManagedObjectOther.comment = "Добавлено"
        transactionsManagedObjectOther.date = Date(timeIntervalSince1970: 1250)
        transactionsManagedObjectOther.img = "house.fill"
        transactionsManagedObjectOther.type = "Доход"
        
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
        let lastTransaction = Transaction(type: "Доход", amount: 2, img: "house.fill", date: Date(timeIntervalSince1970: 2000), comment: "Пусто", category: "Новая")
        
        transactionsService.saveTransaction(lastTransaction)
        
        XCTAssertEqual(coreData.invokedSave, true)
        XCTAssertEqual(coreData.invokedSaveCount, 1)
    }
}
