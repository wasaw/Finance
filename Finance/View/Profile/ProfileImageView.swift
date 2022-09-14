//
//  ProfileImageView.swift
//  Finance
//
//  Created by Александр Меренков on 12.09.2022.
//

import UIKit

class ProfileImageView: UIView {
    
//    MARK: - Properties
            
    private let imageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "add-photo.pgn")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .center
        btn.layer.borderWidth = 3
        return btn
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(imageButton)
        imageButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageButton.anchor(width: 140, height: 140)
        imageButton.layer.cornerRadius = 70
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    func setImage(image: UIImage) {
        imageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.layer.masksToBounds = true
    }
}
