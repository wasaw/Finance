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
        addSubview(titleLable)
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        titleLable.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(totalAccountLabel)
        
        totalAccountLabel.translatesAutoresizingMaskIntoConstraints = false
        totalAccountLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        totalAccountLabel.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10).isActive = true
        totalAccountLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(arrowDownImage)
        
        arrowDownImage.translatesAutoresizingMaskIntoConstraints = false
        arrowDownImage.centerYAnchor.constraint(equalTo: totalAccountLabel.centerYAnchor).isActive = true
        arrowDownImage.leftAnchor.constraint(equalTo: totalAccountLabel.rightAnchor, constant: 10).isActive = true
        arrowDownImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        arrowDownImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(plusImage)
        
        plusImage.translatesAutoresizingMaskIntoConstraints = false
        plusImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        plusImage.topAnchor.constraint(equalTo: totalAccountLabel.bottomAnchor, constant: 25).isActive = true
        plusImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        plusImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
