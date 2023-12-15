//
//  CategoryCell.swift
//  Finance
//
//  Created by Александр Меренков on 18.06.2022.
//

import UIKit

private enum Constants {
    static let titleLabelHeight: CGFloat = 15
    static let imageViewPaddingTop: CGFloat = 10
    static let imageViewDimensions: CGFloat = 30
}

class CategoryCell: UICollectionViewCell {
    static let identifire = "CategoryCell"

// MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .selectedCellBackground
        return view
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
        addSubview(circleView)
        circleView.anchor(width: bounds.width + 10, height: bounds.height + 10)
        circleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        circleView.isHidden = true
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, height: Constants.titleLabelHeight)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        addSubview(imageView)
        
        imageView.anchor(top: titleLabel.bottomAnchor,
                         paddingTop: Constants.imageViewPaddingTop,
                         width: Constants.imageViewDimensions,
                         height: Constants.imageViewDimensions)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setInfornation(title: String, image: UIImage) {
        titleLabel.text = title
        imageView.image = image
    }
    
    func setSelect() {
        circleView.isHidden = false
    }
    
    func disableSelect() {
        circleView.isHidden = true
    }
}
