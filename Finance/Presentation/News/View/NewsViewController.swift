//
//  NewsViewController.swift
//  Finance
//
//  Created by Александр Меренков on 18.10.2023.
//

import UIKit

final class NewsViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: NewsOutput
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource = DataSource(tableView)
    
// MARK: - Lifecycle
    
    init(output: NewsOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        configureUI()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifire)
        view.addSubview(tableView)
        tableView.anchor(leading: view.leadingAnchor,
                         top: view.topAnchor,
                         trailing: view.trailingAnchor,
                         bottom: view.bottomAnchor)
    }
    
    private func setupDataSource(_ news: [NewsItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(news)
        dataSource.apply(snapshot)
    }
}

// MARK: - NewsInput

extension NewsViewController: NewsInput {
    func setNews(_ news: [NewsItem]) {
        DispatchQueue.main.async {
            self.setupDataSource(news)
        }
    }
}
