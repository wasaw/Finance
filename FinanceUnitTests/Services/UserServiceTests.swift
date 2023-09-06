//
//  UserServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.09.2023.
//

import XCTest
@testable import Finance

final class UserServiceTests: XCTestCase {
    
    var coreData: CoreDataServiceProtocolMock!
    var fileStore: FileStoreProtocolMock!
    var firebaseService: FirebaseServiceMock!
    var userService: UserServiceProtocol!
    
    override func setUp() {
        coreData = CoreDataServiceProtocolMock()
        fileStore = FileStoreProtocolMock()
        firebaseService = FirebaseServiceMock()
        userService = UserService(coreData: coreData, fileStore: fileStore, firebaseService: firebaseService)
    }
    
    override func tearDown() {
        coreData = nil
        fileStore = nil
        firebaseService = nil
        userService = nil
    }
    
    func testGetUser() {
        let context = TestCoreDataStack().getMenagedObjectContext()
        let userManagedObject = UserManagedObject(usedContext: context)
        userManagedObject.uid = "0201"
        userManagedObject.login = "First"
        userManagedObject.email = "test@mail.com"
        
        coreData.stubbedFetchUserInformationResult = ([userManagedObject])
        
        userService.getUser("0201") { _ in
        }
        XCTAssertEqual(coreData.invokedFetchUserInformation, true)
        XCTAssertEqual(coreData.invokedFetchUserInformationCount, 1)
    }
    
    func testSaveImage() {
        userService.saveImage(image: UIImage(named: "savings")!, for: "0201") { _ in
        }
        
        XCTAssertEqual(fileStore.invokedSaveImage, true)
        XCTAssertEqual(fileStore.invokedSaveImageCount, 1)
        XCTAssertEqual(firebaseService.invokedSaveImage, true)
        XCTAssertEqual(firebaseService.invokedSaveImageCount, 1)
    }
}
