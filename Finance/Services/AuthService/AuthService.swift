//
//  AuthService.swift
//  Finance
//
//  Created by Александр Меренков on 09.09.2022.
//

import Foundation

final class AuthService {
    
// MARK: - Properties
    
    private let coreData: CoreDataService
    private let firebaseService: FirebaseServiceProtocol
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataService, firebaseService: FirebaseServiceProtocol) {
        self.coreData = coreData
        self.firebaseService = firebaseService
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
    
    @objc private func endSaving() {
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            let uidDataDict: [String: String] = ["uid": uid]
            DispatchQueue.main.async {
                self.notification.post(Notification(name: Notification.Name("updateCredential"), object: nil, userInfo: uidDataDict))
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
        firebaseService.logOut(completion: completion)
    }
    
    func logInUser(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        firebaseService.logIn(withEmail: email, password: password) { result in
            switch result {
            case .success(let uid):
                do {
                    let user = try self.coreData.fetchUserInformation(uid: uid)
                    if user.isEmpty {
                        self.saveUser(uid: uid, login: "", email: email)
                    }
                    UserDefaults.standard.set(uid, forKey: "uid")
                    let userDataDict: [String: String] = ["uid": uid]
                    self.notification.post(name: Notification.Name("updateCredential"), object: nil, userInfo: userDataDict)
                    completion(.success(()))
                } catch {
                    completion(.failure(AuthError.somethingError))
                }
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
    
    func signInUser(credentials: AuthCredentials, completion: @escaping (Result<Void, Error>) -> Void) {
        
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
