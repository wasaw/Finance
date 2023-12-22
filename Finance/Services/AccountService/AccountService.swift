//
//  AccountService.swift
//  Finance
//
//  Created by Александр Меренков on 14.12.2023.
//

import Foundation

final class AccountService {
    
// MARK: - Properties
    
    private let fileStore: FileStoreProtocol
    private let coreData: CoreDataServiceProtocol
    
// MARK: - Lifecycle
    
    init(fileStore: FileStoreProtocol, coreData: CoreDataServiceProtocol) {
        self.fileStore = fileStore
        self.coreData = coreData
    }
}

// MARK: - AccountServiceProtocol

extension AccountService: AccountServiceProtocol {
    func fetchAccounts(completion: @escaping (Result<[Account], Error>) -> Void) {
        do {
            let accountsManagedObject = try coreData.fetchAccounts(nil)
            let accounts: [Account] = accountsManagedObject.compactMap { account in
                guard let id = account.id,
                      let title = account.title,
                      let data = try? fileStore.getImage(id.uuidString) else { return nil }
                return Account(id: id,
                               title: title,
                               amount: account.amount,
                               image: data)
            }
            completion(.success(accounts))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchAccount(for uid: UUID) throws -> Account {
        do {
            let accountsManagedObject = try coreData.fetchAccounts(uid).first
                guard let account = accountsManagedObject,
                      let id = account.id,
                      let title = account.title,
                      let data = try? fileStore.getImage(id.uuidString) else {
                    throw TransactionError.notFound
                }
                return Account(id: id,
                               title: title,
                               amount: account.amount,
                               image: data)
        } catch {
            throw error
        }
    }
}
