//
//  Notice.swift
//  Finance
//
//  Created by Александр Меренков on 17.01.2024.
//

import UIKit

private enum Constants {
    static let horizontalPadding: CGFloat = 15
    static let bottomPadding: CGFloat = 30
    static let viewHeight: CGFloat = 40
    static let cornerRadius: CGFloat = 12
    static let titlePadding: CGFloat = 18
    static let markDimensions: CGFloat = 18
}

final class Notice: UIView {
    static let shared = Notice()
    
// MARK: - Properties
    
    weak var positionView: UIView? {
        didSet {
            configureUI()
        }
    }
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .totalTintColor
        return label
    }()
    private lazy var markView: UIView = {
        let view = UIView()
        return view
    }()
    
// MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)

        alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        anchor(leading: positionView?.leadingAnchor,
               trailing: positionView?.trailingAnchor,
               bottom: positionView?.safeAreaLayoutGuide.bottomAnchor,
               paddingLeading: Constants.horizontalPadding,
               paddingTrailing: -Constants.horizontalPadding,
               paddingBottom: -Constants.bottomPadding,
               height: Constants.viewHeight)
        
        addSubview(titleLabel)
        titleLabel.anchor(trailing: trailingAnchor, paddingTrailing: -Constants.titlePadding)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(markView)
        markView.anchor(leading: leadingAnchor,
                        paddingLeading: Constants.horizontalPadding,
                        width: Constants.markDimensions,
                        height: Constants.markDimensions)
        markView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = 0.8
        layer.borderColor = UIColor.lightGray.cgColor
        backgroundColor = .selectedCellBackground
    }
    
    private func animation() {
        UIView.animate(withDuration: 0.6, delay: 0.5) {
            self.alpha = 1
            self.drawMark()
        } completion: { _ in
            UIView.animate(withDuration: 0.6, delay: 1) {
                self.alpha = 0
            }
        }
    }
    
    private func drawMark() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = .none
        shapeLayer.strokeColor = UIColor.totalTintColor.cgColor
        shapeLayer.lineWidth = 5
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 10))
        bezierPath.addLine(to: CGPoint(x: 12, y: 18))
        bezierPath.addLine(to: CGPoint(x: 24, y: 0))
        
        shapeLayer.path = bezierPath.cgPath
        markView.layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 2
        shapeLayer.add(animation, forKey: "animation")
    }
    
    func configure(_ title: String) {
        titleLabel.text = title
    }
    
    func show() {
        animation()
    }
}
