//
//  FirebaseService.swift
//  Finance
//
//  Created by Александр Меренков on 24.08.2023.
//

import Foundation
import FirebaseAuth

final class FirebaseService {
    
}

// MARK: - FirebaseServiceProtocol

extension FirebaseService: FirebaseServiceProtocol {
    func logIn(withEmail email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            if let uid = result?.user.uid {
                completion(.success(uid))
            }
        }
    }
    
    func signIn(login: String, email: String, password: String, completion: @escaping (Result<String?, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            }
            if let uid = result?.user.uid {
                let value = ["login": login, "email": email]
                REF_USERS.child(uid).updateChildValues(value)
            }
            completion(.success(result?.user.uid))
        }
    }
    
    func authVerification(compeltion: @escaping (Result<String, Error>) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            compeltion(.success(uid))
        } else {
            compeltion(.failure(AuthError.somethingError))
        }
    }
    
    func logOut(completion: @escaping (Result<Void, AuthError>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(AuthError.somethingError))
        }
    }
    
    func saveImage(dataImage: Data, with uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let fileName = UUID().uuidString
        let storageImageRef = REF_PROFILE_IMAGE.child(fileName)
        storageImageRef.putData(dataImage) { _, error in
            if let error = error {
                completion(.failure(error))
            }
            storageImageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let url = url else { return }
                let imageUrl = url.absoluteString
                let values = ["profileImageUrl": imageUrl]
                REF_USERS.child(uid).updateChildValues(values)
            }
        }
    }
    
    func saveTransaction(_ transaction: Transaction) {
        if let uid = Auth.auth().currentUser?.uid {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let value: [String: Any] = ["type": transaction.type,
                         "amount": transaction.amount,
                         "img": transaction.img,
                         "date": formatter.string(from: transaction.date),
                         "comment": transaction.comment,
                         "category": transaction.category]
            REF_USER_TRANSACTIONS.child(uid).childByAutoId().updateChildValues(value)
        }
    }
}
