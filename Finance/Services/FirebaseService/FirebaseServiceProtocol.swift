//
//  FirebaseServiceProtocol.swift
//  Finance
//
//  Created by Александр Меренков on 24.08.2023.
//

import Foundation

protocol FirebaseServiceProtocol: AnyObject {
    func logIn(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signIn(login: String, email: String, password: String, completion: @escaping (Result<String?, Error>) -> Void)
    func authVerification(compeltion: @escaping (Result<String, Error>) -> Void)
    func logOut(completion: @escaping (Result<Void, AuthError>) -> Void)
    func saveImage(dataImage: Data, with uid: String, completion: @escaping (Result<Data, Error>) -> Void)
    func saveTransaction(_ transaction: FirebaseTransaction)
    func fetchTransactions(_ uid: String, completion: @escaping (Result<[FirebaseTransaction], TransactionError>) -> Void)
}
