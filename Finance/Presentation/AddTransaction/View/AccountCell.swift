//
//  AccountCell.swift
//  Finance
//
//  Created by Александр Меренков on 02.02.2023.
//

import UIKit

private enum Constants {
    static let amountLabelHeight: CGFloat = 20
}

final class AccountCell: CategoryCell {
    
// MARK: - Properties
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
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
        contentView.addSubview(amountLabel)
        amountLabel.anchor(bottom: contentView.bottomAnchor, height: Constants.amountLabelHeight)
        amountLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setInfornation(account: AccountCellModel) {
        amountLabel.text = String(format: "%.0f", account.amount) + account.currency.symbol
        guard let image = UIImage(data: account.imageData) else { return }
        super.setInfornation(title: account.title, image: image)
    }
}
