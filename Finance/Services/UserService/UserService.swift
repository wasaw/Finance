//
//  UserService.swift
//  Finance
//
//  Created by Александр Меренков on 09.08.2023.
//

import UIKit

final class UserService {
    
// MARK: - Properties
    
    private let coreData: CoreDataServiceProtocol
    private let fileStore: FileStoreProtocol
    private let firebaseService: FirebaseServiceProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataServiceProtocol,
         fileStore: FileStoreProtocol,
         firebaseService: FirebaseServiceProtocol) {
        self.coreData = coreData
        self.fileStore = fileStore
        self.firebaseService = firebaseService
    }
}

// MARK: - Helpers

extension UserService: UserServiceProtocol {
    func getUser(_ uid: String, completion: @escaping (Result<User, UserLoadError>) -> Void) {
        do {
            let userManagedObject = try coreData.fetchUserInformation(uid: uid)
            if let loadedUser = userManagedObject.first,
               let login = loadedUser.login,
               let email = loadedUser.email {
                   let data = try fileStore.getImage(uid)
                   let user = User(uid: uid, login: login, email: email, profileImage: data)
                   completion(.success(user))
           } else {
               completion(.failure(.isEmptyUser))
           }
        } catch {
            completion(.failure(.isEmptyUser))
        }
    }
    
    func saveImage(image: UIImage, for uid: String, completion: @escaping ((Result<Data, Error>) -> Void)) {
        guard let dataImage = image.jpegData(compressionQuality: 0.7) else { return }
        fileStore.saveImage(data: dataImage, with: uid, completion: completion)
        firebaseService.saveImage(dataImage: dataImage, with: uid, completion: completion)
    }
}
