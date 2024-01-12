//
//  LastTransactionsCell.swift
//  Finance
//
//  Created by Александр Меренков on 10.06.2022.
//

import UIKit

private enum Constants {
    static let horizontalPadding: CGFloat = 20
    static let imageViewDimensions: CGFloat = 35
    static let stackVerticalPadding: CGFloat = 10
}

final class LastTransactionCell: UICollectionViewCell {
    
// MARK: - Properties
    
    static let identifire = "LastTransactionCell"
    
    private let imageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
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
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        contentView.addSubview(imageView)
        imageView.anchor(leading: contentView.leadingAnchor,
                         paddingLeading: Constants.horizontalPadding,
                         width: Constants.imageViewDimensions,
                         height: Constants.imageViewDimensions)
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(amountLabel)
        amountLabel.anchor(trailing: contentView.trailingAnchor)
        amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [categoryLabel, dateLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        contentView.addSubview(stack)
        stack.anchor(leading: imageView.trailingAnchor,
                     top: contentView.topAnchor,
                     trailing: amountLabel.leadingAnchor,
                     bottom: contentView.bottomAnchor,
                     paddingLeading: Constants.horizontalPadding,
                     paddingTop: Constants.stackVerticalPadding,
                     paddingTrailing: -Constants.horizontalPadding,
                     paddingBottom: -Constants.stackVerticalPadding)
        
        backgroundColor = .white
    }
    
    func setInformation(lastTransaction: TransactionCellModel) {
        amountLabel.text = lastTransaction.amount
        categoryLabel.text = lastTransaction.category
        dateLabel.text = lastTransaction.date
        amountLabel.textColor = lastTransaction.isRevenue ? .incomeCash : .outboxCash
        guard let image = UIImage(data: lastTransaction.image) else { return }
        imageView.image = image
    }
}
