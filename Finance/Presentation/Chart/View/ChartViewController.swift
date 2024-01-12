//
//  ChartViewController.swift
//  Finance
//
//  Created by Александр Меренков on 11.01.2024.
//

import UIKit

final class ChartViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: ChartOutput
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource = ChartDataSource(tableView)
    
// MARK: - Lifecycle
    
    init(output: ChartOutput) {
        self.output = output
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        output.viewIsReady()
    }
    
// MARK: - Helpers
    
    private func configureUI() {
        navigationItem.title = "Траты"
        
        view.addSubview(tableView)
        tableView.register(ChartCell.self, forCellReuseIdentifier: ChartCell.reuseIdentifire)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.anchor(leading: view.leadingAnchor,
                         top: view.safeAreaLayoutGuide.topAnchor,
                         trailing: view.trailingAnchor,
                         bottom: view.bottomAnchor)
        view.backgroundColor = .white
    }
    
    private func setupDataSource(_ displayData: [ChartCell.DisplayData]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(displayData)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - ChartInput

extension ChartViewController: ChartInput {
    func showData(_ displayData: [ChartCell.DisplayData]) {
        setupDataSource(displayData)
    }
}

// MARK: - UITableViewDelegate

extension ChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
