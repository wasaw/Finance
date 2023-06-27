//
//  AuthCoordinator.swift
//  Finance
//
//  Created by Александр Меренков on 22.06.2023.
//

import UIKit

final class AuthCoordinator {
    
// MARK: - Properties
    
    private let authAssembly: AuthAssembly
    private let coreData = CoreDataService()
    
// MARK: - Lifecycle
    
    init(authAssembly: AuthAssembly) {
        self.authAssembly = authAssembly
    }
    
// MARK: - Helpers
    
    func start() -> UIViewController {
        let vc = authAssembly.makeAuthModul(authCoordinator: self)
        return vc
    }
}

// MARK: - AuthPresenterOutput

extension AuthCoordinator: AuthPresenterOutput {
    func entrance(email: String, password: String) {
        AuthService.shared.logInUser(email: email, password: password) { result, error in
            if let error = error {
                if error.localizedDescription.contains("The password is invalid") {
//                    self.alert(with: "Внимание", massage: "Введен неверный пароль")
                }
                print("Logging error is \(error.localizedDescription)")
            }
            if let uid = result?.user.uid {
                print(uid)
//                self.delegate?.sendUid(uid: uid)
            }
        }
    }
    
    func registration(credentials: AuthCredentials) {
        AuthService.shared.registerUser(credentials: credentials) { error, ref in
        if let error = error {
            print(error)
//            self.alert(with: "Ошибка", massage: error.localizedDescription)
        } else {
            let uid = ref.url.suffix(28)
            let user = User(uid: String(uid), login: credentials.login, email: credentials.email, profileImageUrl: "", authorized: true)
            self.coreData.save { context in
                let userManagedObject = UserManagedObject(usedContext: context)
                userManagedObject.uid = user.uid
                userManagedObject.login = user.login
                userManagedObject.email = user.email
                userManagedObject.profileImageUrl = user.profileImageUrl?.absoluteString ?? ""
                userManagedObject.authorized = user.authorized
            }
        }
    }
    }
}
