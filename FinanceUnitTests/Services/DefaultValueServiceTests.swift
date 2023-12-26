//
//  DefaultValueServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 03.08.2023.
//

import XCTest
@testable import Finance

final class DefaultValueServiceTests: XCTestCase {
    
    var fileStore: FileStoreMock!
    var defautlValueService: DefaultValueService!
    var coreData: CoreDataServiceMock!
    
    override func setUp() {
        fileStore = FileStoreMock()
        coreData = CoreDataServiceMock()
        defautlValueService = DefaultValueService(fileStore: fileStore,
                                                  coreData: coreData)
    }
    
    override func tearDown() {
        fileStore = nil
        fileStore = nil
        coreData = nil
    }
    
    func testFetchStocks() {
        _ = defautlValueService.fetchStocks()
        XCTAssertEqual(fileStore.invokedReadAppInformation, true)
        XCTAssertEqual(fileStore.invokedReadAppInformationCount, 1)
    }
    
    func testFetchExchageValue() {
        _ = defautlValueService.fetchExchangeValue()
        XCTAssertEqual(fileStore.invokedReadAppInformation, true)
        XCTAssertEqual(fileStore.invokedReadAppInformationCount, 2)
    }
}
