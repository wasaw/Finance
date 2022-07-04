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
    
    private let ammountLabel: UILabel = {
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
        imageView.anchor(left: leftAnchor, paddingLeft: 20, width: 25, height: 25)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(ammountLabel)
        ammountLabel.anchor(right: rightAnchor, width: 70)
        ammountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [reasonLabel, dateLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        addSubview(stack)
        stack.anchor(left: imageView.rightAnchor, top: topAnchor, right: ammountLabel.leftAnchor, bottom: bottomAnchor, paddingLeft: 20, paddingTop: 10, paddingRight: -20, paddingBottom: -10)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
