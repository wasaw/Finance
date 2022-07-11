//
//  CurrencyCell.swift
//  Finance
//
//  Created by Александр Меренков on 08.07.2022.
//

import UIKit

class CurrencyCell: UICollectionViewCell {

//    MARK: - Properties
    
    static let identifire = "CurrencyCell"
    
    private let currencyImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "light-bulb.png")
        return img
    }()
    
    private let shortTitle: UILabel = {
        let label = UILabel()
        label.text = "DLR"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let fullTitle: UILabel = {
        let label = UILabel()
        label.text = "Dollar"
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.text = "23 руб"
        label.font = UIFont.boldSystemFont(ofSize: 21)
        return label
    }()
    
    private let dividingLine: UIView = {
        let line = UIView()
        line.backgroundColor = .lightGray
        return line
    }()

    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        addSubview(currencyImage)
        currencyImage.anchor(left: leftAnchor, top: topAnchor, bottom: bottomAnchor, paddingLeft: 20, paddingTop: 20, paddingBottom: -20, width: 50, height: 50)
        
        let titleStack = UIStackView(arrangedSubviews: [shortTitle, fullTitle])
        titleStack.axis = .vertical
        titleStack.distribution = .equalSpacing
        addSubview(titleStack)
        titleStack.anchor(left: currencyImage.rightAnchor, top: topAnchor, bottom: bottomAnchor, paddingLeft: 15, paddingTop: 20, paddingBottom: -20, width: 120)
        
        addSubview(valueLabel)
        valueLabel.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, paddingTop: 20, paddingRight: -20, paddingBottom: -20, width: 80)
        
        addSubview(dividingLine)
        dividingLine.anchor(left: leftAnchor, top: currencyImage.bottomAnchor, right: rightAnchor, paddingLeft: 20, paddingTop: 15, paddingRight: -20, height: 1)
    }
}
