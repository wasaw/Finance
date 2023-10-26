//
//  NewsViewController.swift
//  Finance
//
//  Created by Александр Меренков on 18.10.2023.
//

import UIKit

private enum Constants {
    static let rowHeight: CGFloat = 150
    static let loadPadding: CGFloat = 25
}

final class NewsViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: NewsOutput
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource = DataSource(tableView)
    private lazy var loadAnimationView = CircleAnimation()
    private lazy var refreshController = UIRefreshControl()
    
// MARK: - Lifecycle
    
    init(output: NewsOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
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
        navigationItem.title = "Новости"
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseIdentifire)
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.anchor(leading: view.leadingAnchor,
                         top: view.topAnchor,
                         trailing: view.trailingAnchor,
                         bottom: view.bottomAnchor)
        tableView.addSubview(loadAnimationView)
        refreshController.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshController)
        loadAnimationView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        loadAnimationView.anchor(top: tableView.topAnchor,
                                 paddingTop: Constants.loadPadding)
        loadAnimationView.configureAnimation()
    }
    
    private func setupDataSource(_ news: [NewsItem]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(news)
        dataSource.apply(snapshot)
    }
    
// MARK: - Selectors
    
    @objc private func refresh() {
        output.updateData()
    }
}

// MARK: - NewsInput

extension NewsViewController: NewsInput {
    func setLoading(enable: Bool) {
        loadAnimationView.isHidden = !enable
        refreshController.endRefreshing()
    }
    
    func setNews(_ news: [NewsItem]) {
        DispatchQueue.main.async {
            self.setupDataSource(news)
        }
    }
}

// MARK: - UITableViewDelegate

extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output.showWebView(for: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}
