//
//  UserService.swift
//  Finance
//
//  Created by Александр Меренков on 09.08.2023.
//

import UIKit

final class UserService {
    
// MARK: - Properties
    
    private let coreData: CoreDataService
    private let fileStore: FileStoreProtocol
    
// MARK: - Lifecycle
    
    init(coreData: CoreDataService, fileStore: FileStoreProtocol) {
        self.coreData = coreData
        self.fileStore = fileStore
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
                if let imageData = fileStore.getImage(uid) {
                    image = UIImage(data: imageData)
                }
                return User(uid: uid,
                            login: login,
                            email: email,
                            profileImage: image)
            }
            return user.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveImage(image: UIImage, for uid: String) {
        guard let dataImage = image.jpegData(compressionQuality: 0.7) else { return }
        fileStore.saveImage(data: dataImage, with: uid)
    }
    
    func getImage(uid: String) -> UIImage? {
        guard let imageData = fileStore.getImage(uid) else { return nil}
        let image = UIImage(data: imageData)
        return image
    }
}
