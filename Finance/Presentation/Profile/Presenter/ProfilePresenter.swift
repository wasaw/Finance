//
//  ProfilePresenter.swift
//  Finance
//
//  Created by Александр Меренков on 13.06.2023.
//

import Foundation
import Firebase

final class ProfilePresenter {
    
// MARK: - Properties
    
    weak var input: ProfileInput?
    
}

// MARK: - Output

extension ProfilePresenter: ProfileOutput {
    func viewIsReady() {
        if Auth.auth().currentUser == nil {
            print("DEBUG: not auth")
            input?.showAuth()
//            addAuthController()
        } else {
            print("DEBUG: auth")
//            configureUI()
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
//            currentUser.deleteValue()
//            addAuthController()
        } catch let error {
            print("Error is \(error.localizedDescription)")
        }
    }
}
