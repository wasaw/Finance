//
//  TypeCell.swift
//  Finance
//
//  Created by Александр Меренков on 02.02.2023.
//

import UIKit

final class TypeCell: CategoryCell {
    
//    MARK: - Properties
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        addSubview(amountLabel)
        amountLabel.anchor(top: imageView.bottomAnchor, paddingTop: 5, height: 20)
        amountLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override func setInfornation(title: String, img: String, amount: Double = 0, currency: Currency) {
        amountLabel.text = String(format: "%.0f", amount) + currency.getMark()
        super.setInfornation(title: title, img: img, amount: amount, currency: currency)
    }
}
