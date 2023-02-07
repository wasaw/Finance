//
//  UserService.swift
//  Finance
//
//  Created by Александр Меренков on 14.09.2022.
//

import Firebase

final class UserService {
    static let shared = UserService()
    
    func uploadDate(complition: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(uid).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            complition(user)
        }
    }
}
