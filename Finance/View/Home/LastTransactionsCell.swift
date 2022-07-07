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
        return img
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let reasonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .totalAccountTintColor
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .totalAccountTintColor
        label.layer.opacity = 0.7
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(left: leftAnchor, paddingLeft: 20, width: 35, height: 35)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(amountLabel)
        amountLabel.anchor(right: rightAnchor, width: 70)
        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [reasonLabel, dateLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        addSubview(stack)
        stack.anchor(left: imageView.rightAnchor, top: topAnchor, right: amountLabel.leftAnchor, bottom: bottomAnchor, paddingLeft: 20, paddingTop: 10, paddingRight: -20, paddingBottom: -10)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    func setInformation(lastTransaction: LastTransaction) {
        amountLabel.text = String(lastTransaction.amount) + " ₽"
        reasonLabel.text = lastTransaction.comment
        imageView.image = UIImage(named: lastTransaction.img)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: lastTransaction.date)
    }
}
