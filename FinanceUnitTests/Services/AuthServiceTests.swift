//
//  AuthServiceTests.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.09.2023.
//

import XCTest
@testable import Finance

final class AuthServiceTests: XCTestCase {
    
    var coreData: CoreDataServiceProtocolMock!
    var firebaseService: FirebaseServiceMock!
    var authService: AuthService!
    
    override func setUp() {
        coreData = CoreDataServiceProtocolMock()
        firebaseService = FirebaseServiceMock()
        authService = AuthService(coreData: coreData, firebaseService: firebaseService)
    }
    
    override func tearDown() {
        coreData = nil
        firebaseService = nil
        authService = nil
    }
    
    func testAuthVerification() {
        authService.authVerification { _ in
        }
        
        XCTAssertEqual(firebaseService.invokedAuthVerification, true)
        XCTAssertEqual(firebaseService.invokedAuthVerificationCount, 1)
    }
    
    func testLogOut() {
        authService.logOut { _ in
        }
        
        XCTAssertEqual(firebaseService.invokedLogOut, true)
        XCTAssertEqual(firebaseService.invokedLogOutCount, 1)
    }
    
    func testSignInUser() {
        let regCredentials = RegCredentials(login: "TestUser",
                                            email: "Test@mail.com",
                                            password: "123",
                                            confirmPass: "123")
        authService.signInUser(credentials: regCredentials) { _ in
        }
        
        XCTAssertEqual(firebaseService.invokedSignIn, true)
        XCTAssertEqual(firebaseService.invokedSignInCount, 1)
        XCTAssertEqual(firebaseService.invokedSignInParameters?.login, regCredentials.login)
    }
    
    func testLogInUser() {
        let authCredentials = AuthCredentials(email: "auth@mail.com", password: "123")
        authService.logInUser(credentials: authCredentials) { _ in
        }
        
        XCTAssertEqual(firebaseService.invokedLogIn, true)
        XCTAssertEqual(firebaseService.invokedLogInCount, 1)
        XCTAssertEqual(firebaseService.invokedLogInParameters?.email, authCredentials.email)
    }
}
