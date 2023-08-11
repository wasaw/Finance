//
//  AuthService.swift
//  Finance
//
//  Created by Александр Меренков on 09.09.2022.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

final class AuthService {
    
// MARK: - Properties
    
    weak var profilePresenterInput: ProfilePresenterInput?
    private let coreData: CoreDataService
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataService) {
        self.coreData = coreData
    }
}

// MARK: - AuthServiceProtocol

extension AuthService: AuthServiceProtocol {
    func authVerification() -> String? {
        if let uid = Auth.auth().currentUser?.uid {
            return uid
        } else {
            return nil
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(nil, forKey: "uid")
            profilePresenterInput?.showAuth()
        } catch let error {
            print("Error is \(error.localizedDescription)")
        }
    }
    
    func logInUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                if error.localizedDescription.contains("The password is invalid") {
            //      self.alert(with: "Внимание", massage: "Введен неверный пароль")
                }
                print("Logging error is \(error.localizedDescription)")
                completion(false)
            }
            if let uid = result?.user.uid {
                do {
                    let user = try self.coreData.fetchUserInformation(uid: uid)
                    if user.isEmpty {
                        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                            guard let dictionary = snapshot.value as? [String: AnyObject],
                                    let login = dictionary["login"] as? String,
                                    let email = dictionary["email"] as? String else { return }
                            self.coreData.save { context in
                                let userManagedObject = UserManagedObject(context: context)
                                userManagedObject.uid = uid
                                userManagedObject.login = login
                                userManagedObject.email = email
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                UserDefaults.standard.set(uid, forKey: "uid")
                let uidDataDict: [String: String] = ["uid": uid]
                self.notification.post(Notification(name: Notification.Name("updateCredential"), object: nil, userInfo: uidDataDict))
                self.profilePresenterInput?.updateCredential(uid)
                completion(true)
            }
        }
    }
    
    func signInUser(credentials: AuthCredentials, completion: @escaping ((Bool) -> Void)) {
        
        let login = credentials.login
        let email = credentials.email
        let password = credentials.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error is \(error.localizedDescription)")
                completion(false)
            }
            
            guard let uid = result?.user.uid else { return }
            let values = ["login": login, "email": email]
            REF_USERS.child(uid).updateChildValues(values)
            self.coreData.save { context in
                let userManagedObject = UserManagedObject(usedContext: context)
                userManagedObject.uid = uid
                userManagedObject.login = credentials.login
                userManagedObject.email = credentials.email
            }
//            let uidDataDict: [String: String] = ["uid": uid]
//            self.notification.post(Notification(name: Notification.Name("updateCredential"), object: nil, userInfo: uidDataDict))
            completion(true)
        }
    }
}
