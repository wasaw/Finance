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
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(costLabel)
        
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        costLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        costLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        costLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
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
