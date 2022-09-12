//
//  AuthService.swift
//  Finance
//
//  Created by Александр Меренков on 09.09.2022.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct AuthService {
    static let shared = AuthService()
    
    func logInUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping (Error?,DatabaseReference) -> Void) {
        let login = credentials.username
        let email = credentials.email
        let password = credentials.password
                
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error is \(error.localizedDescription)")
            }
            
            guard let uid = result?.user.uid else { return }
            let values = ["login": login, "email": email]
            
            REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
        }
    }
}
