//
//  ServicesCell.swift
//  Finance
//
//  Created by Александр Меренков on 09.06.2022.
//

import UIKit

class ServicesCell: UICollectionViewCell {
    
//    MARK: - Properties
    static let identifire = "ServiceCell"
    
    private let viewForImage: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.backgroundColor = .servicesCellImageBackground
        return view
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "user.png")
        return image
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .totalAccountTintColor
        label.textAlignment = .center
        label.text = "Название"
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(viewForImage)
        
        viewForImage.translatesAutoresizingMaskIntoConstraints = false
        viewForImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        viewForImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        viewForImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        viewForImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        viewForImage.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: viewForImage.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: viewForImage.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(titleLable)
        
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLable.topAnchor.constraint(equalTo: viewForImage.bottomAnchor, constant: 10).isActive = true
        titleLable.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLable.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
