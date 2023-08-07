//
//  DefaultValueServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 03.08.2023.
//

import XCTest
@testable import Finance

final class DefaultValueServiceTests: XCTestCase {
    
    var fileStore: FileStoreProtocolMock!
    var defautlValueService: DefaultValueService!
    
    override func setUp() {
        fileStore = FileStoreProtocolMock()
        defautlValueService = DefaultValueService(fileStore: fileStore)
    }
    
    override func tearDown() {
        fileStore = nil
        fileStore = nil
    }

    func testFetchValue() throws {
        do {
            _ = try defautlValueService.fetchValue()
            XCTAssertEqual(fileStore.invokedReadAppInformation, true)
            XCTAssertEqual(fileStore.invokedReadAppInformationCount, 2)
        } catch {
            XCTAssertThrowsError(true)
        }
    }
}
