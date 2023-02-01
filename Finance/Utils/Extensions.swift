//
//  Extensions.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

//    MARK: - Colors

extension UIColor {
    static let totalTintColor = UIColor(displayP3Red: 0, green: 53/255, blue: 102/255, alpha: 1)
    static let selectViewBackground = UIColor(displayP3Red: 255/255, green: 191/255, blue: 0, alpha: 1)
    static let servicesCellImageBackground = UIColor(displayP3Red: 228/255, green: 252/255, blue: 255/255, alpha: 1)
    static let tabBarBackgroundColor = UIColor(displayP3Red: 26/255, green: 35/255, blue: 75/255, alpha: 1)
//    LogIn
    static let logInButtonBackground = UIColor(displayP3Red: 2/255, green: 62/255, blue: 255/255, alpha: 1)
    static let logInBackgroundColor = UIColor(displayP3Red: 245/255, green: 246/255, blue: 255/255, alpha: 1)
//    Add
    static let selectedCellBackground = UIColor(displayP3Red: 228/255, green: 252/255, blue: 255/255, alpha: 1)
}

//  MARK: - UITextField

extension UITextField {
    func addLine() {
        let textFieldLine = CALayer()
        textFieldLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
        textFieldLine.backgroundColor = UIColor.black.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(textFieldLine)
    }
}

//  MARK: - UIView

extension UIView {
    func anchor (left: NSLayoutXAxisAnchor? = nil,
                 top: NSLayoutYAxisAnchor? = nil,
                 right: NSLayoutXAxisAnchor? = nil,
                 bottom: NSLayoutYAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0,
                 paddingTop: CGFloat = 0,
                 paddingRight: CGFloat = 0,
                 paddingBottom: CGFloat = 0,
                 width: CGFloat? = nil,
                 height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

//  MARK: - UIViewController

extension UIViewController {
    func alert(with title: String, massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}
