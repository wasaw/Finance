//
//  ChartCell.swift
//  Finance
//
//  Created by Александр Меренков on 11.01.2024.
//

import UIKit

private enum Constants {
    static let horizontalPadding: CGFloat = 20
    static let imageViewDimensions: CGFloat = 35
    static let categoryLabelPadding: CGFloat = 20
}

final class ChartCell: UITableViewCell {
    static let reuseIdentifire = "ChartCell"
    
// MARK: - Properties
    
    struct DisplayData: Hashable {
        let image: Data
        let title: String
        let amount: String
    }
    
    private lazy var categoryImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .totalTintColor
        return label
    }()
    private lazy var persentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textAlignment = .right
        label.textColor = .totalTintColor
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
        contentView.addSubview(categoryImage)
        categoryImage.anchor(leading: contentView.leadingAnchor,
                             paddingLeading: Constants.horizontalPadding,
                             width: Constants.imageViewDimensions,
                             height: Constants.imageViewDimensions)
        categoryImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(persentLabel)
        persentLabel.anchor(trailing: contentView.trailingAnchor, paddingTrailing: -Constants.horizontalPadding)
        persentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(categoryLabel)
        categoryLabel.anchor(leading: categoryImage.trailingAnchor,
                     top: contentView.topAnchor,
                     trailing: persentLabel.leadingAnchor,
                     bottom: contentView.bottomAnchor,
                     paddingLeading: Constants.horizontalPadding,
                     paddingTop: Constants.categoryLabelPadding,
                     paddingTrailing: -Constants.horizontalPadding,
                     paddingBottom: -Constants.categoryLabelPadding)
    }
        
    func configure(_ model: DisplayData) {
        categoryImage.image = UIImage(data: model.image)
        categoryLabel.text = model.title
        persentLabel.text = model.amount
    }
}
