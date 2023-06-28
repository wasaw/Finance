//
//  ProfileImageView.swift
//  Finance
//
//  Created by Александр Меренков on 12.09.2022.
//

import UIKit

private enum Constants {
    static let imageButtonDimensions: CGFloat = 140
    static let imageButtonCornerRadius: CGFloat = 70
}

protocol ProfileImageSelectDelegate: AnyObject {
    func selectImage()
}

final class ProfileImageView: UIView {
    
// MARK: - Properties
    
    weak var delegate: ProfileImageSelectDelegate?
            
    private lazy var imageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "add-photo.pgn")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .center
        btn.layer.borderWidth = 3
        btn.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return btn
    }()
    
// MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(imageButton)
        imageButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageButton.anchor(width: Constants.imageButtonDimensions,
                           height: Constants.imageButtonDimensions)
        imageButton.layer.cornerRadius = Constants.imageButtonCornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    func setImage(image: UIImage) {
        imageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        imageButton.imageView?.contentMode = .scaleAspectFill
        imageButton.layer.masksToBounds = true
    }
    
    func setImage(complition: @escaping (UIButton) -> Void) {
        complition(imageButton)
    }
// MARK: - Selectors

    @objc private func handleAddPhoto() {
        delegate?.selectImage()
    }
}
