//
//  TotalAccountView.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

class TotalAccountView: UIView {
    
//    MARK: - Propertries
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = .totalAccountTintColor
        label.alpha = 0.4
        label.text = "Ваш баланс"
        return label
    }()
    
    private let totalAccountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textColor = .totalAccountTintColor
        label.text = "5700 $"
        return label
    }()
    
    private let arrowDownImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "arrow-down")?.withTintColor(.totalAccountTintColor)
        return img
    }()
    
    private let plusImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "plus.png")?.withTintColor(.totalAccountTintColor)
        return img
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        layer.cornerRadius = 20
        
        backgroundColor = .totalAccountBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        addSubview(totalAccountLabel)
        totalAccountLabel.anchor(height: 40)
        totalAccountLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        totalAccountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(titleLable)
        titleLable.anchor(bottom: totalAccountLabel.topAnchor, paddingBottom: -15, height: 25)
        titleLable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
        addSubview(arrowDownImage)
        arrowDownImage.anchor(left: totalAccountLabel.rightAnchor, paddingLeft: 10, width: 25, height: 25)
        arrowDownImage.centerYAnchor.constraint(equalTo: totalAccountLabel.centerYAnchor).isActive = true
    }
}
