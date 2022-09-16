//
//  ProfileController.swift
//  Finance
//
//  Created by Александр Меренков on 09.09.2022.
//

import UIKit
import Firebase
import SDWebImage

class ProfileController: UIViewController {

//    MARK: - Properties
    
    private var currentCurrency: Currency = .rub
    
    private let imagePicker = UIImagePickerController()
    private let imageView = ProfileImageView()
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 23)
        label.textAlignment = .center
        return label
    }()
    
    private var currentCurrencyBtn = Utils().menuItemButton(image: "currencies.png", title: "Текущая валюта")
    private let logOutBtn = Utils().menuItemButton(image: "logout.png", title: "Выход")

//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        UserService.shared.uploadDate { [weak self] user in
            if user.profileImageUrl != nil {
                self?.imageView.setImage { button in
                    let transformer = SDImageResizingTransformer(size: CGSize(width: 140, height: 140), scaleMode: .fill)
                    button.sd_setImage(with: user.profileImageUrl, for: .normal, placeholderImage: nil, context: [.imageTransformer: transformer])
                    button.layer.masksToBounds = true
                }
            }
            self?.loginLabel.text = user.login
        }
        
        imageView.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        view.addSubview(imageView)
        imageView.anchor(left: view.leftAnchor, top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 15, paddingRight: -10, height: 150)
        
        view.addSubview(loginLabel)
        loginLabel.anchor(left: view.leftAnchor, top: imageView.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, height: 20)
        
        let stack = UIStackView(arrangedSubviews: [currentCurrencyBtn, logOutBtn])
        stack.axis = .vertical
        stack.spacing = 15
        view.addSubview(stack)
        stack.anchor(left: view.leftAnchor, top: loginLabel.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingTop: 130, paddingRight: -20)

        currentCurrencyBtn.menu = generationMenu()
        currentCurrencyBtn.showsMenuAsPrimaryAction = true
    }
    
    private func generationMenu() -> UIMenu {
        let first = createUIAction(title: "Рубль", image: "ruble-currency.png", displayedCurrency: .rub)
        let second = createUIAction(title: "Доллар", image: "dollar.png", displayedCurrency: .dollar)
        let third = createUIAction(title: "Евро", image: "euro.png", displayedCurrency: .euro)
        let elements = [first, second, third]
        let menu = UIMenu(children: elements)
        return menu
    }
    
    private func createUIAction(title: String, image: String, displayedCurrency: Currency) -> UIAction {
        return UIAction(title: title, image: UIImage(named: image), state: checkCurrency(currency: displayedCurrency) ? .on : .off) { _ in
            self.currentCurrency = displayedCurrency
            self.currentCurrencyBtn.menu = self.generationMenu()
        }
    }
    
    private func checkCurrency(currency: Currency) -> Bool {
        return currency == currentCurrency ? true : false
    }
    
//    MARK: - Selecters
    
    @objc private func handleLogOutBtn() {
        do {
            try Auth.auth().signOut()
            authAndConfigureUI()
        } catch let error {
            print("Error is \(error.localizedDescription)")
        }
    }
}

//  MARK: - Extensions

extension ProfileController: ProfileImageSelectDelegate {
    func selectImage() {
        present(imagePicker, animated: true)
    }
}

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        
        imageView.setImage(image: profileImage)
        dismiss(animated: true)

        guard let dataImage = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = UUID().uuidString
        let storageImageRef = REF_PROFILE_IMAGE.child(filename)
        
        storageImageRef.putData(dataImage) { meta, error in
            storageImageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let values = ["profileImageUrl": profileImageUrl]
                REF_USERS.child(uid).updateChildValues(values)
            }
        }
    }
}