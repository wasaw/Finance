//
//  CurrencyCell.swift
//  Finance
//
//  Created by Александр Меренков on 08.07.2022.
//

import UIKit

final class CurrencyCell: UICollectionViewCell {

// MARK: - Properties
    
    static let identifire = "CurrencyCell"
    
    private let currencyImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private let shortTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let fullTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()
    
    private let dividingLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()

// MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        addSubview(currencyImage)
        currencyImage.anchor(leading: leadingAnchor,
                             top: topAnchor,
                             bottom: bottomAnchor,
                             paddingLeading: 20,
                             paddingTop: 20,
                             paddingBottom: -20,
                             width: 40,
                             height: 40)
        
        let titleStack = UIStackView(arrangedSubviews: [shortTitle, fullTitle])
        titleStack.axis = .vertical
        titleStack.distribution = .equalSpacing
        addSubview(titleStack)
        titleStack.anchor(leading: currencyImage.trailingAnchor,
                          top: topAnchor,
                          bottom: bottomAnchor,
                          paddingLeading: 15,
                          paddingTop: 20,
                          paddingBottom: -20,
                          width: 200)
        
        addSubview(valueLabel)
        valueLabel.anchor(top: topAnchor,
                          trailing: trailingAnchor,
                          bottom: bottomAnchor,
                          paddingTop: 20,
                          paddingTrailing: -20,
                          paddingBottom: -20,
                          width: 110)
        
        addSubview(dividingLine)
        dividingLine.anchor(leading: leadingAnchor,
                            top: currencyImage.bottomAnchor,
                            trailing: trailingAnchor,
                            paddingLeading: 20,
                            paddingTop: 15,
                            paddingTrailing: -20,
                            height: 1)
    }
    
    func setInformation(currency: CurrentExchangeRate) {
        shortTitle.text = currency.name
        valueLabel.text = String(format: "%.3f", currency.amount)
        fullTitle.text = currency.fullName
        currencyImage.image = UIImage(named: currency.img)
    }
}
