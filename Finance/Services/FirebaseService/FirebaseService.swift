//
//  FirebaseService.swift
//  Finance
//
//  Created by Александр Меренков on 24.08.2023.
//

import Foundation
import FirebaseAuth

struct FirebaseTransaction {
    let account: String
    let category: String
    let amount: Double
    let date: Date
    let comment: String
}

final class FirebaseService {
    
// MARK: - Properties
    
    private let network: NetworkProtocol
    private let fileStore: FileStoreProtocol
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(network: NetworkProtocol,
         fileStore: FileStoreProtocol) {
        self.network = network
        self.fileStore = fileStore
    }
    
    deinit {
        notification.removeObserver(self)
    }
}

// MARK: - FirebaseServiceProtocol

extension FirebaseService: FirebaseServiceProtocol {
    func logIn(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
            }
            if let uid = result?.user.uid {
                REF_USERS.child(uid).getData { error, snapshot in
                    if let error = error {
                        completion(.failure(error))
                    }
                    
                    let value = snapshot?.value as? NSDictionary
                    let email = value?["email"] as? String ?? ""
                    let login = value?["login"] as? String ?? ""
                    if let imgUrl = value?["profileImageUrl"] as? String {
                        guard let url = URL(string: imgUrl) else { return }
                        let request = URLRequest(url: url)
                        self?.network.loadImage(request: request) { result in
                            switch result {
                            case .success(let imageData):
                                self?.fileStore.saveImage(data: imageData, with: uid) { result in
                                    switch result {
                                    case .success:
                                        let uidDataDict: [String: String] = ["uid": uid]
                                        DispatchQueue.main.async {
                                            self?.notification.post(Notification(name: .updateCredential,
                                                                                 object: nil,
                                                                                 userInfo: uidDataDict))
                                        }
                                    case .failure:
                                        break
                                    }
                                }
                            case .failure:
                                break
                            }
                        }
                    }
                    let user = User(uid: uid, login: login, email: email)
                    completion(.success(user))
                }
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
    
    func saveImage(dataImage: Data, with uid: String, completion: @escaping (Result<Data, Error>) -> Void) {
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
    
    func saveTransaction(_ transaction: FirebaseTransaction) {
        let dateFormatter = DateFormat.shared
        
        if let uid = Auth.auth().currentUser?.uid {
            let value: [String: Any] = [
                        "account": transaction.account,
                        "amount": transaction.amount,
                        "date": dateFormatter.formatter(from: transaction.date),
                        "comment": transaction.comment,
                        "category": transaction.category]
            REF_USER_TRANSACTIONS.child(uid).childByAutoId().updateChildValues(value)
        }
    }
    
    func fetchTransactions(_ uid: String, completion: @escaping (Result<[FirebaseTransaction], TransactionError>) -> Void) {
        REF_USER_TRANSACTIONS.child(uid).getData { error, snapshot in
            if error != nil {
                completion(.failure(TransactionError.notFound))
            }
            
            guard let value = snapshot?.value as? NSDictionary else { return }
            var transactions: [FirebaseTransaction] = []
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            for item in value {
                guard let list = item.value as? NSDictionary,
                      let account = list["account"] as? String,
                      let amount = list["amount"] as? Double,
                      let category = list["category"] as? String,
                      let comment = list["comment"] as? String,
                      let dateString = list["date"] as? String,
                      let date = formatter.date(from: dateString) else { return }
                let transaction = FirebaseTransaction(account: account,
                                              category: category,
                                              amount: amount,
                                              date: date,
                                              comment: comment)
                transactions.append(transaction)
            }
            completion(.success(transactions))
        }
    }
}
