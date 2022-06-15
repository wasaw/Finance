//
//  Extensions.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit

//    MARK: - Colors

extension UIColor {
    static let totalAccountTintColor = UIColor(displayP3Red: 0, green: 53/255, blue: 102/255, alpha: 1)
    static let totalAccountBackground = UIColor(displayP3Red: 255/255, green: 191/255, blue: 0, alpha: 1)
    static let servicesCellImageBackground = UIColor(displayP3Red: 228/255, green: 252/255, blue: 255/255, alpha: 1)
    static let tabBarBackgroundColor = UIColor(displayP3Red: 26/255, green: 35/255, blue: 75/255, alpha: 1)
//    LogIn
    static let logInButtonBackground = UIColor(displayP3Red: 2/255, green: 62/255, blue: 255/255, alpha: 1)
    static let logInBackgroundColor = UIColor(displayP3Red: 245/255, green: 246/255, blue: 255/255, alpha: 1)
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
