//
//  CurrencyCell.swift
//  Finance
//
//  Created by Александр Меренков on 08.07.2022.
//

import UIKit

private enum Constants {
    static let horizontalPadding: CGFloat = 20
    static let paddingTopTwenty: CGFloat = 20
    static let paddingBottomTwenty: CGFloat = 20
    static let currencyImageDimensions: CGFloat = 40
    static let titleStackWidth: CGFloat = 200
    static let valueLabelWidth: CGFloat = 110
    static let dividingLineHeight: CGFloat = 1
}

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
                             paddingLeading: Constants.horizontalPadding,
                             paddingTop: Constants.paddingTopTwenty,
                             paddingBottom: -Constants.paddingBottomTwenty,
                             width: Constants.currencyImageDimensions)
        
        let titleStack = UIStackView(arrangedSubviews: [shortTitle, fullTitle])
        titleStack.axis = .vertical
        titleStack.distribution = .equalSpacing
        addSubview(titleStack)
        titleStack.anchor(leading: currencyImage.trailingAnchor,
                          top: topAnchor,
                          bottom: bottomAnchor,
                          paddingLeading: Constants.horizontalPadding,
                          paddingTop: Constants.paddingTopTwenty,
                          paddingBottom: -Constants.paddingBottomTwenty,
                          width: Constants.titleStackWidth)
        
        addSubview(valueLabel)
        valueLabel.anchor(top: topAnchor,
                          trailing: trailingAnchor,
                          bottom: bottomAnchor,
                          paddingTop: Constants.paddingTopTwenty,
                          paddingTrailing: -Constants.horizontalPadding,
                          paddingBottom: -Constants.paddingBottomTwenty,
                          width: Constants.valueLabelWidth)
        
        addSubview(dividingLine)
        dividingLine.anchor(leading: leadingAnchor,
                            top: currencyImage.bottomAnchor,
                            trailing: trailingAnchor,
                            paddingLeading: Constants.horizontalPadding,
                            paddingTop: Constants.paddingTopTwenty,
                            paddingTrailing: -Constants.horizontalPadding,
                            height: Constants.dividingLineHeight)
    }
    
    func setInformation(currency: CurrentExchangeRate) {
        shortTitle.text = currency.name
        valueLabel.text = String(format: "%.3f", currency.amount)
        fullTitle.text = currency.fullName
        currencyImage.image = UIImage(named: currency.img)
    }
}
