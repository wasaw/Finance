//
//  ChartViewController.swift
//  Finance
//
//  Created by Александр Меренков on 11.01.2024.
//

import UIKit
import DGCharts

private enum Constants {
    static let pieHeight: CGFloat = 290
}

final class ChartViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: ChartOutput
    private lazy var loadAnimateView = CircleAnimation()
    private lazy var tableView = UITableView(frame: .zero)
    private lazy var dataSource = ChartDataSource(tableView)
    private lazy var pieView: PieChartView = {
        let view = PieChartView()
        view.rotationAngle = 0
        view.rotationEnabled = false
        view.legend.enabled = false
        return view
    }()
    
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
        
        view.addSubview(loadAnimateView)
        loadAnimateView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        loadAnimateView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadAnimateView.configureAnimation()
        
        view.addSubview(pieView)
        pieView.anchor(leading: view.leadingAnchor,
                       top: view.safeAreaLayoutGuide.topAnchor,
                       trailing: view.trailingAnchor,
                       height: Constants.pieHeight)
        
        view.addSubview(tableView)
        tableView.register(ChartCell.self, forCellReuseIdentifier: ChartCell.reuseIdentifire)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.anchor(leading: view.leadingAnchor,
                         top: pieView.bottomAnchor,
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
    
    func showPieData(_ displayData: PieChartDataSet) {
        pieView.data = PieChartData(dataSet: displayData)
    }
    
    func showAlert(_ message: String) {
        alert(with: "Внимание", message: message)
    }
    
    func setLoading(enable: Bool) {
        if enable {
            loadAnimateView.isHidden = false
        } else {
            loadAnimateView.isHidden = true
        }
    }
}

// MARK: - UITableViewDelegate

extension ChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output.didSelectItem(at: indexPath.row)
    }
}
