//
//  TransactionsServiceTest.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 04.08.2023.
//

import XCTest
@testable import Finance

final class TransactionsServiceTest: XCTestCase {
    
    var coreData: CoreDataServiceProtocolMock!
    var transactionsService: TransactionsServiceProtocol!
    
    override func setUp() {
        coreData = CoreDataServiceProtocolMock()
        transactionsService = TransactionsService(coreData: coreData)
    }
    
    override func tearDown() {
        coreData = nil
        transactionsService = nil
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
            XCTAssertEqual(answer[0].category, "Новая")
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
        
        coreData.stubbedFetchTransactionsByRevenueResult = ([transactionsManagedObject, transactionsManagedObjectOther])
        
        do {
            let answer = try transactionsService.fetchAmountBy("Зарплата")
            XCTAssertEqual(coreData.invokedFetchTransactionsByRevenue, true)
            XCTAssertEqual(answer, 439)
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
