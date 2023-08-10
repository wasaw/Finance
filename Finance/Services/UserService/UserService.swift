//
//  UserService.swift
//  Finance
//
//  Created by Александр Меренков on 09.08.2023.
//

import Foundation

final class UserService {
    
// MARK: - Properties
    
    private let coreData: CoreDataService
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataService) {
        self.coreData = coreData
    }
}

// MARK: - Helpers

extension UserService: UserServiceProtocol {
    func getUser(_ uid: String) -> User? {
        do {
            let userManagedObject = try coreData.fetchUserInformation(uid: uid)
            let user: [User] = userManagedObject.compactMap { loadedUser in
                guard let login = loadedUser.login,
                      let email = loadedUser.email,
                      let imageUrl = loadedUser.profileImageUrl else { return nil }
                return User(uid: uid,
                            login: login,
                            email: email,
                            profileImageUrl: imageUrl,
                            authorized: loadedUser.authorized)
            }
            return user.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
