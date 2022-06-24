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
        label.text = "Ваше имя"
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
        profileImage.anchor(left: leftAnchor, width: 50, height: 50)
        
        addSubview(fullNameLabel)
        fullNameLabel.anchor(left: profileImage.rightAnchor, top: profileImage.topAnchor, paddingLeft: 10, width: 140)
    }
}
