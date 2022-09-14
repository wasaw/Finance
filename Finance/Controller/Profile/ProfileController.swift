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
    
    private let imagePicker = UIImagePickerController()
    private let imageView = ProfileImageView()
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textAlignment = .center
        return label
    }()
    
    private let currentCurrencyBtn = Utils().menuItemButton(image: "currencies.png", label: "Текущая валюта")
    private let logOutBtn = Utils().menuItemButton(image: "logout.png", label: "Выход")

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

        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 15, paddingRight: -10, height: 150)
        
        view.addSubview(loginLabel)
        loginLabel.anchor(left: view.leftAnchor, top: imageView.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, height: 20)
        
        let stack = UIStackView(arrangedSubviews: [currentCurrencyBtn, logOutBtn])
        stack.axis = .vertical
        stack.spacing = 15
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, top: loginLabel.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingTop: 130, paddingRight: -20)
    }
    
    private func logOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error is \(error.localizedDescription)")
        }
    }
}
