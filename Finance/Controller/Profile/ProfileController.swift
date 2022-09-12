//
//  ProfileController.swift
//  Finance
//
//  Created by Александр Меренков on 09.09.2022.
//

import UIKit
import Firebase

class ProfileController: UIViewController {

//    MARK: - Properties
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        logOut()
        authAndConfigureUI()
        view.backgroundColor = .white
    }
    
//    MARK: - Helpers
    
    private func authAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            let vc = AuthController()
            vc.modalPresentationStyle = .currentContext
            present(vc, animated: false)
        }
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error is \(error.localizedDescription)")
        }
    }
}
