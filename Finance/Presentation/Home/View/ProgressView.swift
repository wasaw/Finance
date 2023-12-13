//
//  ProgressView.swift
//  Finance
//
//  Created by Александр Меренков on 09.11.2023.
//

import UIKit

private enum Constants {
    static let paddingTop: CGFloat = 15
    static let horizontalPadding: CGFloat = 10
    static let paddingBottom: CGFloat = 35
    static let purposePaddingTop: CGFloat = 5
    static let progressHeight: CGFloat = 35
    static let dividingWidth: CGFloat = 0.8
    static let dividingHeight: CGFloat = 65
    static let cornderRadius: CGFloat = 20
    static let borderWidth: CGFloat = 0.8
    static let transformX: CGFloat = 0.95
    static let transformY: CGFloat = 1
}

final class ProgressView: UIView {
    
// MARK: - Properties
    
    private lazy var expenseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 29)
        label.textColor = .totalTintColor
        return label
    }()
    
    private lazy var expenseDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "в этом месяце"
        label.font = UIFont.systemFont(ofSize: 21)
        label.textColor = .totalTintColor
        return label
    }()
    
    private lazy var dividingLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 27)
        label.textColor = .totalTintColor
        label.textAlignment = .center
        return label
    }()
    
    private lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = .selectedCellBackground
        progressView.clipsToBounds = true
        return progressView
    }()
    
    private lazy var purposeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .totalTintColor
        return label
    }()
    
// MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        addSubview(progressBar)
        progressBar.anchor(leading: leadingAnchor,
                           trailing: trailingAnchor,
                           bottom: bottomAnchor,
                           paddingBottom: -Constants.paddingBottom,
                           height: Constants.progressHeight)
        progressBar.transform = progressBar.transform.scaledBy(x: Constants.transformX,
                                                               y: Constants.transformY)
        layer.borderWidth = Constants.borderWidth
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = Constants.cornderRadius
        
        addSubview(dividingLine)
        dividingLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dividingLine.anchor(top: topAnchor,
                            paddingTop: Constants.paddingTop,
                            width: Constants.dividingWidth,
                            height: Constants.dividingHeight)
        
        let stackView = UIStackView(arrangedSubviews: [expenseLabel, expenseDescriptionLabel])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.anchor(leading: leadingAnchor,
                         top: topAnchor,
                         trailing: dividingLine.leadingAnchor,
                         paddingLeading: Constants.horizontalPadding,
                         paddingTop: Constants.paddingTop,
                         paddingTrailing: -Constants.horizontalPadding)

        addSubview(daysLabel)
        daysLabel.anchor(leading: dividingLine.trailingAnchor,
                         top: topAnchor,
                         trailing: trailingAnchor,
                         paddingLeading: Constants.horizontalPadding,
                         paddingTop: Constants.paddingTop,
                         paddingTrailing: -Constants.horizontalPadding)
        
        addSubview(purposeLabel)
        purposeLabel.anchor(top: progressBar.bottomAnchor,
                            trailing: progressBar.trailingAnchor,
                            paddingTop: Constants.purposePaddingTop,
                            paddingTrailing: -Constants.horizontalPadding)
    }
    
    func setValue(_ progress: Progress) {
        expenseLabel.text = String(format: "%.0f", progress.amount) + progress.currency.getMark()
        daysLabel.text = String(progress.currentDay) + " дней"
        progressBar.setProgress(progress.ratio, animated: true)
        purposeLabel.text = "Цель " + progress.purposeOutput + progress.currency.getMark()
        if progress.amount > progress.purpose {
            progressBar.tintColor = .red
            progressBar.trackTintColor = .white
        }
    }
}
