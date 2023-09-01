//
//  FirebaseServiceMock.swift
//  FinanceUnitTests
//
//  Created by Александр Меренков on 01.09.2023.
//

import Foundation
@testable import Finance

final class FirebaseServiceMock: FirebaseServiceProtocol {

    var invokedLogIn = false
    var invokedLogInCount = 0
    var invokedLogInParameters: (email: String, password: String)?
    var invokedLogInParametersList = [(email: String, password: String)]()
    var stubbedLogInCompletionResult: (Result<String, Error>, Void)?

    func logIn(withEmail email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        invokedLogIn = true
        invokedLogInCount += 1
        invokedLogInParameters = (email, password)
        invokedLogInParametersList.append((email, password))
        if let result = stubbedLogInCompletionResult {
            completion(result.0)
        }
    }

    var invokedSignIn = false
    var invokedSignInCount = 0
    var invokedSignInParameters: (login: String, email: String, password: String)?
    var invokedSignInParametersList = [(login: String, email: String, password: String)]()
    var stubbedSignInCompletionResult: (Result<String?, Error>, Void)?

    func signIn(login: String, email: String, password: String, completion: @escaping (Result<String?, Error>) -> Void) {
        invokedSignIn = true
        invokedSignInCount += 1
        invokedSignInParameters = (login, email, password)
        invokedSignInParametersList.append((login, email, password))
        if let result = stubbedSignInCompletionResult {
            completion(result.0)
        }
    }

    var invokedAuthVerification = false
    var invokedAuthVerificationCount = 0
    var stubbedAuthVerificationCompeltionResult: (Result<String, Error>, Void)?

    func authVerification(compeltion: @escaping (Result<String, Error>) -> Void) {
        invokedAuthVerification = true
        invokedAuthVerificationCount += 1
        if let result = stubbedAuthVerificationCompeltionResult {
            compeltion(result.0)
        }
    }

    var invokedLogOut = false
    var invokedLogOutCount = 0
    var stubbedLogOutCompletionResult: (Result<Void, AuthError>, Void)?

    func logOut(completion: @escaping (Result<Void, AuthError>) -> Void) {
        invokedLogOut = true
        invokedLogOutCount += 1
        if let result = stubbedLogOutCompletionResult {
            completion(result.0)
        }
    }

    var invokedSaveImage = false
    var invokedSaveImageCount = 0
    var invokedSaveImageParameters: (dataImage: Data, uid: String)?
    var invokedSaveImageParametersList = [(dataImage: Data, uid: String)]()
    var stubbedSaveImageCompletionResult: (Result<Void, Error>, Void)?

    func saveImage(dataImage: Data, with uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        invokedSaveImage = true
        invokedSaveImageCount += 1
        invokedSaveImageParameters = (dataImage, uid)
        invokedSaveImageParametersList.append((dataImage, uid))
        if let result = stubbedSaveImageCompletionResult {
            completion(result.0)
        }
    }
}
