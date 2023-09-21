//
//  Extensions.swift
//  Finance
//
//  Created by Александр Меренков on 08.06.2022.
//

import UIKit
import CoreData

// MARK: - Colors

extension UIColor {
    static let totalTintColor = UIColor(displayP3Red: 0, green: 53 / 255, blue: 102 / 255, alpha: 1)
    static let selectViewBackground = UIColor(displayP3Red: 255 / 255, green: 191 / 255, blue: 0, alpha: 1)
    static let servicesCellImageBackground = UIColor(displayP3Red: 228 / 255, green: 252 / 255, blue: 255 / 255, alpha: 1)
    static let tabBarBackgroundColor = UIColor(displayP3Red: 26 / 255, green: 35 / 255, blue: 75 / 255, alpha: 1)
//    LogIn
    static let logInButtonBackground = UIColor(displayP3Red: 2 / 255, green: 62 / 255, blue: 255 / 255, alpha: 1)
    static let logInBackgroundColor = UIColor(displayP3Red: 245 / 255, green: 246 / 255, blue: 255 / 255, alpha: 1)
//    Add
    static let selectedCellBackground = UIColor(displayP3Red: 228 / 255, green: 252 / 255, blue: 255 / 255, alpha: 1)
}

// MARK: - UITextField

extension UITextField {
    func addLine() {
        let textFieldLine = CALayer()
        textFieldLine.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1)
        textFieldLine.backgroundColor = UIColor.black.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(textFieldLine)
    }
}

// MARK: - UIView

extension UIView {
    func anchor (leading: NSLayoutXAxisAnchor? = nil,
                 top: NSLayoutYAxisAnchor? = nil,
                 trailing: NSLayoutXAxisAnchor? = nil,
                 bottom: NSLayoutYAxisAnchor? = nil,
                 paddingLeading: CGFloat = 0,
                 paddingTop: CGFloat = 0,
                 paddingTrailing: CGFloat = 0,
                 paddingBottom: CGFloat = 0,
                 width: CGFloat? = nil,
                 height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: paddingTrailing).isActive = true
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

// MARK: - UIViewController

extension UIViewController {
    func alert(with title: String, message: String, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: completion))
        self.present(alert, animated: true)
    }
}

// MARK: - NSManagerObject

extension NSManagedObject {
    convenience init(usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext) else {
            self.init(context: usedContext)
            return
        }
        self.init(entity: entity, insertInto: usedContext)
    }
}
