//
//  NewsCell.swift
//  Finance
//
//  Created by Александр Меренков on 19.10.2023.
//

import UIKit

final class NewsCell: UITableViewCell {
    static let reuseIdentifire = "NewsCell"
    
// MARK: - Properties
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "text"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        contentView.addSubview(label)
        label.anchor(leading: contentView.leadingAnchor, top: contentView.topAnchor)
    }
    
    func configure(with news: NewsItem) {
        label.text = news.title
    }
}
