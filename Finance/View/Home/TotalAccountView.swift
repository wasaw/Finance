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
        label.textColor = .totalTintColor
        label.alpha = 0.4
        label.text = "Ваш баланс"
        return label
    }()
    
    private let totalAccountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 38)
        label.textColor = .totalTintColor
        return label
    }()
    
    private let plusImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "plus.png")?.withTintColor(.totalTintColor)
        return img
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        layer.cornerRadius = 20
        
        backgroundColor = .selectViewBackground
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
        titleLable.anchor(bottom: totalAccountLabel.topAnchor, paddingBottom: -10, height: 25)
        titleLable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setAccountLabel(total: Int) {
        totalAccountLabel.text = String(total) + " ₽"
    }
}
