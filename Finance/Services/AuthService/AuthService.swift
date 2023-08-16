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
                            self.saveUser(uid: uid, login: login, email: email)
                        }
                    } else {
                        UserDefaults.standard.set(uid, forKey: "uid")
                        let userDataDict: [String: String] = ["uid": uid]
                        self.notification.post(name: Notification.Name("updateCredential"), object: nil, userInfo: userDataDict)
                    }
                } catch {
                    print(error.localizedDescription)
                }
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
            self.saveUser(uid: uid, login: credentials.login, email: credentials.email)
            completion(true)
        }
    }
}
