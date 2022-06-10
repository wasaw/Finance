//
//  ProfileHeaderView.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

class ProfileHeaderView: UIView {
    
//    MARK: - Properties
    
    private let profileImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "user.png")?.withTintColor(.totalAccountTintColor)
        img.layer.cornerRadius = 25
        return img
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Full Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        addSubview(profileImage)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(fullNameLabel)
        
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10).isActive = true
        fullNameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        fullNameLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
}
