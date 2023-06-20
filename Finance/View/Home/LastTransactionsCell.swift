//
//  LastTransactionsCell.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2022.
//

import UIKit

class LastTransactionCell: UICollectionViewCell {
    
// MARK: - Properties
    
    static let identifire = "LastTransactionCell"
    
    private let imageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .totalTintColor
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .totalTintColor
        label.layer.opacity = 0.7
        return label
    }()
    
// MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(leading: leadingAnchor,
                         paddingLeading: 20,
                         width: 35,
                         height: 35)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(amountLabel)
        amountLabel.anchor(trailing: trailingAnchor)
        amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [categoryLabel, dateLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        addSubview(stack)
        stack.anchor(leading: imageView.trailingAnchor,
                     top: topAnchor,
                     trailing: amountLabel.leadingAnchor,
                     bottom: bottomAnchor,
                     paddingLeading: 20,
                     paddingTop: 10,
                     paddingTrailing: -20,
                     paddingBottom: -10)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    func setInformation(lastTransaction: LastTransaction, currency: Currency, rate: Double) {
        let transaction = lastTransaction.amount / rate
        amountLabel.text = String(format: "%.2f", transaction) + currency.getMark()
        categoryLabel.text = lastTransaction.category
        imageView.image = UIImage(named: lastTransaction.img)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: lastTransaction.date)
    }
}
