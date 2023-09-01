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
    func getUser(_ uid: String) -> User? {
        do {
            let userManagedObject = try coreData.fetchUserInformation(uid: uid)
            let user: [User] = userManagedObject.compactMap { loadedUser in
                guard let login = loadedUser.login,
                      let email = loadedUser.email else { return nil }
                var image: UIImage?
                fileStore.getImage(uid) { result in
                    switch result {
                    case .success(let data):
                        image = UIImage(data: data)
                    case .failure:
                        image = UIImage(named: "add-photo")
                    }
                }
                return User(uid: uid,
                            login: login,
                            email: email,
                            profileImage: image)
            }
            return user.first
        } catch {
            return nil
        }
    }
    
    func saveImage(image: UIImage, for uid: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let dataImage = image.jpegData(compressionQuality: 0.7) else { return }
        fileStore.saveImage(data: dataImage, with: uid, completion: completion)
        firebaseService.saveImage(dataImage: dataImage, with: uid, completion: completion)
    }
}
