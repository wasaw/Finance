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
    private let authService: AuthServiceProtocol
    
// MARK: - Lifecycle
    
    init(authService: AuthServiceProtocol) {
        self.authService = authService
        self.authService.profilePresenterInput = self
    }
    
}

// MARK: - Output

extension ProfilePresenter: ProfileOutput {
    func viewIsReady() {
        input?.showProfile()
        if !authService.authVerification() {
            input?.showAuth()
        }
    }
    
    func logOut() {
        authService.logOut()
    }
}

// MARK: - ProfilePresenterInput

extension ProfilePresenter: ProfilePresenterInput {
    func showAuth() {
        input?.showAuth()
    }
}
