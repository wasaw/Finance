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
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 45
        view.backgroundColor = .selectedCellBackground
        return view
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
        addSubview(circleView)
        circleView.anchor(width: bounds.width, height: bounds.height)
        circleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        circleView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        circleView.isHidden = true
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, height: 15)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(imageView)
        imageView.anchor(top: titleLabel.bottomAnchor, paddingTop: 10, width: 30, height: 30)
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(amountLabel)
        amountLabel.anchor(top: imageView.bottomAnchor, height: 20)
        amountLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func setInfornation(title: String, img: String, amount: Int = 0) {
        titleLabel.text = title
        imageView.image = UIImage(named: img)
        amountLabel.text = String(amount) + " руб."
    }
    
    func hideAmount(_ isHidden: Bool) {
        amountLabel.isHidden = isHidden
    }
    
    func setSelect() {
        circleView.isHidden = false
    }
    
    func disableSelect() {
        circleView.isHidden = true
    }
}
