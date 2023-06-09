//
//  Animations.swift
//  Finance
//
//  Created by Александр Меренков on 30.01.2023.
//

import UIKit

class CircleAnimation: UIView {
    
// MARK: - Properties
    
    private let loadLeftView = UIView()
    private let loadCenterView = UIView()
    private let loadRightView = UIView()
    
// MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLoadView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureLoadView() {
        layer.borderWidth = 1
        
        addSubview(loadLeftView)
        loadLeftView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -20).isActive = true
        loadLeftView.anchor(top: topAnchor, width: 30, height: 30)
        
        addSubview(loadCenterView)
        loadCenterView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadCenterView.anchor(top: topAnchor, width: 30, height: 30)
        
        addSubview(loadRightView)
        loadRightView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 20).isActive = true
        loadRightView.anchor(top: topAnchor, width: 30, height: 30)
        
        let circleLeftPath = UIBezierPath(arcCenter: CGPoint(x: 15, y: 15), radius: 5, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
        let circleCenterPath = UIBezierPath(arcCenter: CGPoint(x: 15, y: 15), radius: 5, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
        let circleRightPath = UIBezierPath(arcCenter: CGPoint(x: 15, y: 15), radius: 5, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
        
        let shapeLeftLayer = CAShapeLayer()
        shapeLeftLayer.path = circleLeftPath.cgPath
        shapeLeftLayer.fillColor = UIColor.green.cgColor
        
        let shapeCenterLayer = CAShapeLayer()
        shapeCenterLayer.path = circleCenterPath.cgPath
        shapeCenterLayer.fillColor = UIColor.blue.cgColor
        
        let shapeRightLayer = CAShapeLayer()
        shapeRightLayer.path = circleRightPath.cgPath
        shapeRightLayer.fillColor = UIColor.green.cgColor
                
        loadLeftView.layer.addSublayer(shapeLeftLayer)
        loadCenterView.layer.addSublayer(shapeCenterLayer)
        loadRightView.layer.addSublayer(shapeRightLayer)
        
        loadLeftView.isHidden = false
        loadCenterView.isHidden = false
        loadRightView.isHidden = false
    }
    
    func configureAnimation() {
        let animationUP = CABasicAnimation(keyPath: "transform.scale")
        animationUP.duration = 1
        animationUP.fromValue = 1
        animationUP.toValue = 2
        animationUP.repeatCount = .infinity
        animationUP.autoreverses = true
        
        let animationDown = CABasicAnimation(keyPath: "transform.scale")
        animationDown.duration = 1
        animationDown.fromValue = 2
        animationDown.toValue = 1
        animationDown.repeatCount = .infinity
        animationDown.autoreverses = true
        
        animationUP.delegate = self
        animationDown.delegate = self
        
        loadLeftView.layer.add(animationDown, forKey: nil)
        loadCenterView.layer.add(animationUP, forKey: nil)
        loadRightView.layer.add(animationDown, forKey: nil)
    }
}

// MARK: - CAAnimationDelegate

extension CircleAnimation: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        loadLeftView.layer.removeAllAnimations()
        loadCenterView.layer.removeAllAnimations()
        loadRightView.layer.removeAllAnimations()
    }
}
