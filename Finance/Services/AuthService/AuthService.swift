//
//  AuthService.swift
//  Finance
//
//  Created by Александр Меренков on 09.09.2022.
//

import Foundation

final class AuthService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    private let firebaseService: FirebaseServiceProtocol
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol, firebaseService: FirebaseServiceProtocol) {
        self.coreData = coreData
        self.firebaseService = firebaseService
    }
    
    deinit {
        notification.removeObserver(self)
    }
    
// MARK: - Helpers
    
    private func saveUser(uid: String, login: String, email: String) {
        UserDefaults.standard.set(uid, forKey: "uid")
        self.coreData.save { context in
            let userManagedObject = UserManagedObject(context: context)
            userManagedObject.uid = uid
            userManagedObject.login = login
            userManagedObject.email = email
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.endSaving),
                                                   name: Notification.Name.NSManagedObjectContextDidSave,
                                                   object: nil)
        }
    }
    
// MARK: - Selectors
    
    @objc private func endSaving(_ notification: Notification) {
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            let uidDataDict: [String: String] = ["uid": uid]
            DispatchQueue.main.async {
                self.notification.post(Notification(name: .updateCredential, object: nil, userInfo: uidDataDict))
                self.notification.post(Notification(name: .updateTransactions, object: nil))
            }
        }
    }
}

// MARK: - AuthServiceProtocol

extension AuthService: AuthServiceProtocol {
    func authVerification(completion: @escaping (Result<String, Error>) -> Void) {
        firebaseService.authVerification(compeltion: completion)
    }
    
    func logOut(completion: @escaping (Result<Void, AuthError>) -> Void) {
        coreData.deleteUser()
        coreData.deleteTransactions()
        firebaseService.logOut(completion: completion)
    }
    
    func logInUser(credentials: AuthCredentials, completion: @escaping (Result<Void, AuthError>) -> Void) {
        firebaseService.logIn(withEmail: credentials.email, password: credentials.password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.saveUser(uid: user.uid, login: user.login, email: user.email)
                self?.firebaseService.fetchTransactions(user.uid, completion: { result in
                    switch result {
                    case .success(let transactions):
                        transactions.forEach { transaction in
                            self?.coreData.save { context in
                                let transactionManagedObject = TransactionManagedObject(context: context)
                                transactionManagedObject.type = transaction.type
                                transactionManagedObject.category = transaction.category
                                transactionManagedObject.img = transaction.img
                                transactionManagedObject.date = transaction.date
                                transactionManagedObject.amount = transaction.amount
                                transactionManagedObject.comment = transaction.comment
                            }
                        }
                        self?.notification.post(Notification(name: .addTransactions, object: nil))
                    case .failure(let error):
                        switch error {
                        case .notFound:
                            completion(.failure(AuthError.noIdentifier))
                        }
                    }
                })
                let userDataDict: [String: String] = ["uid": user.uid]
                self?.notification.post(name: .updateCredential, object: nil, userInfo: userDataDict)
                completion(.success(()))
            case .failure(let error):
                if error.localizedDescription.contains("The password is invalid") {
                    completion(.failure(.invalidPassword))
                }
                if error.localizedDescription.contains("There is no user record corresponding to this identifier") {
                    completion(.failure(.noIdentifier))
                }
                if error.localizedDescription.contains("The email address is badly formatted") {
                    completion(.failure(.emailBadlyFormatted))
                }
                completion(.failure(AuthError.somethingError))
            }
        }
    }
    
    func signInUser(credentials: RegCredentials, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let login = credentials.login
        let email = credentials.email
        let password = credentials.password
        
        firebaseService.signIn(login: login, email: email, password: password) { result in
            switch result {
            case .success(let uid):
                guard let uid = uid else { return }
                self.saveUser(uid: uid, login: login, email: email)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
