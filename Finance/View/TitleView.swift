//
//  TitleView.swift
//  Finance
//
//  Created by Александр Меренков on 09.06.2022.
//

import UIKit

class TitleView: UIView {
    
//    MARK: - Properties
        
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textColor = .totalAccountTintColor
        return label
    }()
    
    private let arrowImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "arrow-down.png")?.withTintColor(.totalAccountTintColor)
        img.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi / 2))
        return img
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        addSubview(titleLable)
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(arrowImage)
        arrowImage.anchor(right: rightAnchor, width: 20, height: 20)
        arrowImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    func setTitle(title: String) {
        titleLable.text = title
    }
}
