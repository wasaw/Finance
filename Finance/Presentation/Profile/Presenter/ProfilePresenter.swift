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
    private let userService: UserServiceProtocol
    private let notification = NotificationCenter.default
    
// MARK: - Lifecycle
    
    init(authService: AuthServiceProtocol, userService: UserServiceProtocol) {
        self.authService = authService
        self.userService = userService
        self.authService.profilePresenterInput = self
        notification.addObserver(self, selector: #selector(updateCredentiall(_:)), name: Notification.Name("updateCredential"), object: nil)
    }
    
// MARK: - Selectors
    
    @objc private func updateCredentiall(_ notification: NSNotification) {
        if let uid = notification.userInfo?["uid"] as? String {
            if let user = userService.getUser(uid) {
                input?.showUserCredential(user)
            }
        }
    }
}

// MARK: - Output

extension ProfilePresenter: ProfileOutput {
    func viewIsReady() {
        input?.showProfile()
        if let uid = authService.authVerification() {
            if let user = userService.getUser(uid) {
                input?.showUserCredential(user)
                guard let image = userService.getImage(uid: uid) else { return }
                input?.setUserImage(image)
            }
        } else {
            input?.showAuth()
        }
    }
    
    func logOut() {
        authService.logOut()
    }
    
    func saveImage(_ imageData: Any?) {
        guard let image = imageData as? UIImage else { return }
        input?.setUserImage(image)
        if let uid = UserDefaults.standard.value(forKey: "uid") as? String {
            userService.saveImage(image: image, for: uid)
        }
    }
}

// MARK: - ProfilePresenterInput

extension ProfilePresenter: ProfilePresenterInput {
    func showAuth() {
        input?.showAuth()
    }
    
    func updateCredential(_ uid: String) {
        if let user = userService.getUser(uid) {
            input?.showUserCredential(user)
        }
    }
}
