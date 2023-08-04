//
//  DefaultValueServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 03.08.2023.
//

import XCTest
@testable import Finance

final class DefaultValueServiceTests: XCTestCase {

    func testFetchValue() throws {
        let fileStore = FileStoreProtocolMock()
        let defautlValueService = DefaultValueService(fileStore: fileStore)

        do {
            let _ = try defautlValueService.fetchValue()
            XCTAssertEqual(fileStore.invokedReadAppInformation, true)
            XCTAssertEqual(fileStore.invokedReadAppInformationCount, 2)
        } catch {
            XCTAssertThrowsError(true)
        }
    }
}
