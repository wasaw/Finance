//
//  StockCell.swift
//  Finance
//
//  Created by Александр Меренков on 31.01.2023.
//

import UIKit

final class StockCell: UITableViewCell {
    static let reuseIdentifite = "stockCell"
    
//    MARK: - Properties
    
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
    
//    MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(symbolLabel)
        symbolLabel.anchor(left: leftAnchor, top: topAnchor, paddingLeft: 25, paddingTop: 10)
        
        addSubview(valueLabel)
        valueLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 10, paddingRight: -40)
    }
    
    func setValue(stock: Stock, index: Int) {
        symbolLabel.text = stock.symbol
        valueLabel.text = String(stock.value)
        if index % 2 == 0 {
            backgroundColor = .white
        } else {
            backgroundColor = .lightGray
        }
    }
}
