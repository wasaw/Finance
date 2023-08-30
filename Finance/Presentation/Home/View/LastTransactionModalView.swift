//
//  LastTransactionModalView.swift
//  Finance
//
//  Created by Александр Меренков on 23.08.2022.
//

import UIKit

private enum Constants {
    static let horizontalPadding: CGFloat = 10
    static let verticalPadding: CGFloat = 20
}

final class LastTransactionModalView: UIView {
    
// MARK: - Properties
        
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .totalTintColor
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23)
        label.textColor = .totalTintColor
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23)
        label.textColor = .totalTintColor
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23)
        label.textColor = .totalTintColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .totalTintColor
        return label
    }()
    
// MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [typeLabel, amountLabel, categoryLabel, commentLabel, dateLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 16
        addSubview(stack)
        
        stack.anchor(leading: leadingAnchor,
                     top: topAnchor,
                     trailing: trailingAnchor,
                     bottom: bottomAnchor,
                     paddingLeading: Constants.horizontalPadding,
                     paddingTop: Constants.verticalPadding,
                     paddingTrailing: -Constants.horizontalPadding,
                     paddingBottom: -Constants.verticalPadding)
    }
    
    func setInformation(_ transaction: Transaction, currency: Currency, rate: Double) {
        typeLabel.text = transaction.type
        let amount = transaction.amount / rate
        amountLabel.text = String(format: "%.2f", amount) + currency.getMark()
        if transaction.amount >= 0 {
            amountLabel.textColor = .systemGreen
        } else {
            amountLabel.textColor = .red
        }
        commentLabel.text = transaction.comment
        categoryLabel.text = transaction.category
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: transaction.date)
    }
}
