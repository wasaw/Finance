//
//  AddCell.swift
//  Finance
//
//  Created by Александр Меренков on 18.06.2022.
//

import UIKit

class AddCell: UICollectionViewCell {
    
//    MARK: - Properties
    
    static let identifire = "AddCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
//        label.text = "Наличка"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.text = "0 руб."
        return label
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
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, height: 15)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(imageView)
        imageView.anchor(top: titleLabel.bottomAnchor, paddingTop: 10, width: 30, height: 30)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(costLabel)
        costLabel.anchor(top: imageView.bottomAnchor, height: 20)
        costLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func hideCost(_ isHidden: Bool) {
        costLabel.isHidden = isHidden
    }
    
    func setImage(img: String) {
        imageView.image = UIImage(named: img)
    }
}
