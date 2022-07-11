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
        label.numberOfLines = 0
        label.lineBreakMode = .byClipping
        return label
    }()
    
//    MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(viewForImage)
        viewForImage.anchor(left: leftAnchor, top: topAnchor, right: rightAnchor, height: 80)
        
        viewForImage.addSubview(imageView)
        imageView.anchor(width: 30, height: 30)
        imageView.centerXAnchor.constraint(equalTo: viewForImage.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: viewForImage.centerYAnchor).isActive = true
        
        addSubview(titleLable)
        titleLable.anchor(left: leftAnchor, top: viewForImage.bottomAnchor, right: rightAnchor, paddingTop: 10, height: 20)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helpers
    
    func setInformation(service: ChoiceService) {
        titleLable.text = service.name
        imageView.image = UIImage(named: service.img)
    }
}
