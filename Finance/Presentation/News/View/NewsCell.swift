//
//  NewsCell.swift
//  Finance
//
//  Created by Александр Меренков on 19.10.2023.
//

import UIKit

private enum Constants {
    static let contentPadding: CGFloat = 5
    static let newsImageWidth: CGFloat = 160
}

final class NewsCell: UITableViewCell {
    static let reuseIdentifire = "NewsCell"
    
// MARK: - Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var newsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var newsImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    private lazy var textView: UIView = {
        let view = UIView()
        return view
    }()
    
// MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: Constants.contentPadding,
                                                                     left: 0,
                                                                     bottom: Constants.contentPadding,
                                                                     right: 0))
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        contentView.addSubview(newsImage)
        newsImage.anchor(top: contentView.topAnchor,
                         trailing: contentView.trailingAnchor,
                         bottom: contentView.bottomAnchor,
                         paddingTop: Constants.contentPadding,
                         paddingTrailing: -Constants.contentPadding,
                         paddingBottom: -Constants.contentPadding,
                         width: Constants.newsImageWidth)
        contentView.addSubview(dateLabel)
        dateLabel.anchor(leading: contentView.leadingAnchor,
                         bottom: newsImage.bottomAnchor,
                         paddingLeading: Constants.contentPadding)
        contentView.addSubview(titleLabel)
        titleLabel.anchor(leading: contentView.leadingAnchor,
                          top: contentView.topAnchor,
                          trailing: newsImage.leadingAnchor,
                          bottom: dateLabel.topAnchor,
                          paddingLeading: Constants.contentPadding,
                          paddingTrailing: -Constants.contentPadding)
    }
    
    func configure(with news: NewsItem) {
        titleLabel.text = news.title
        dateLabel.text = news.date
        newsImage.load(news.imageUrl)
    }
}
