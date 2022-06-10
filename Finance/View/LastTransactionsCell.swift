//
//  LastTransactionsCell.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2022.
//

import UIKit

class LastTransactionCell: UICollectionViewCell {
    
//    MARK: - Properties
    static let identifire = "LastTransactionCell"
    
    private let imageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "light-bulb.png")
        return img
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.text = "-520$"
        return label
    }()
    
    private let reasonLabel: UILabel = {
        let label = UILabel()
        label.text = "Electricity payment"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .totalAccountTintColor
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "19:01, 02/10/2021"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .totalAccountTintColor
        label.layer.opacity = 0.7
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant:  20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(costLabel)
        
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        costLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        costLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [reasonLabel, dateLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        stack.rightAnchor.constraint(equalTo: costLabel.leftAnchor, constant: -20).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        backgroundColor = .backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
