//
//  AllTransactionsCell.swift
//  Finance
//
//  Created by Александр Меренков on 16.01.2024.
//

import UIKit

private enum Constants {
    static let horizontalPadding: CGFloat = 16
}

final class AllTransactionsCell: UITableViewCell {
    static let reuseIdentifire = "AllTransactionsCell"
    
// MARK: - Properties
    
    struct DisplayData: Hashable {
        let id = UUID()
        let title: String
        let date: String
    }
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textAlignment = .right
        label.textColor = .outboxCash
        return label
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .totalTintColor
        label.layer.opacity = 0.7
        return label
    }()
    
// MARK: - Helpers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        contentView.addSubview(amountLabel)
        amountLabel.anchor(trailing: contentView.trailingAnchor, paddingTrailing: -Constants.horizontalPadding)
        amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(dateLabel)
        dateLabel.anchor(leading: contentView.leadingAnchor, paddingLeading: Constants.horizontalPadding)
        dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func configure(_ model: DisplayData) {
        amountLabel.text = model.title
        dateLabel.text = model.date
    }
}
