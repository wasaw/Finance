//
//  Utils.swift
//  Finance
//
//  Created by Александр Меренков on 14.09.2022.
//

import UIKit

class Utils {
    func menuItemButton(image name: String, title: String) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .white
        button.anchor(height: 60)
        let imageView = UIImageView()
        imageView.image = UIImage(named: name)
        button.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        imageView.anchor(leading: button.leadingAnchor, width: 40, height: 40)

        let label = UILabel()
        label.text = title
        label.textColor = .totalTintColor
        label.font = UIFont.boldSystemFont(ofSize: 21)
        button.addSubview(label)
        label.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        label.anchor(leading: imageView.trailingAnchor, paddingLeading: 15)

        let viewLine = UIView()
        viewLine.backgroundColor = .lightGray
        button.addSubview(viewLine)
        viewLine.anchor(leading: button.leadingAnchor,
                        trailing: button.trailingAnchor,
                        bottom: button.bottomAnchor,
                        height: 1)
        return button
    }
}
