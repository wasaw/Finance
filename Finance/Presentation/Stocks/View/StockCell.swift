//
//  StockCell.swift
//  Finance
//
//  Created by Александр Меренков on 31.01.2023.
//

import UIKit

private enum Constants {
    static let symbolLabelPaddingLeading: CGFloat = 25
    static let paddingTopTen: CGFloat = 10
    static let valueLabelPaddingTrailing: CGFloat = 40
}

final class StockCell: UITableViewCell {
    static let reuseIdentifite = "stockCell"
    
// MARK: - Properties
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
// MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {        
        addSubview(symbolLabel)
        symbolLabel.anchor(leading: leadingAnchor,
                           top: topAnchor,
                           paddingLeading: Constants.symbolLabelPaddingLeading,
                           paddingTop: Constants.paddingTopTen)
        
        addSubview(valueLabel)
        valueLabel.anchor(top: topAnchor,
                          trailing: trailingAnchor,
                          paddingTop: Constants.paddingTopTen,
                          paddingTrailing: -Constants.valueLabelPaddingTrailing)
    }
    
    func setValue(stock: Stock, index: Int) {
        symbolLabel.text = stock.symbol
        valueLabel.text = stock.valueOutput
        if index % 2 == 0 {
            backgroundColor = .white
        } else {
            backgroundColor = .lightGray
        }
    }
}
