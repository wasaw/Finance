//
//  ExchangeRateController.swift
//  Finance
//
//  Created by Александр Меренков on 08.07.2022.
//

import UIKit

class ExchangeRateController: UIViewController {
    
//    MARK: - Properties
    
    private let topView = TopView()
    private var listCurrencyCollectionView: UICollectionView?
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureCollectionView()
        
        view.backgroundColor = .white
    }
    
//    MARK: - Helpers
    
    private func configureUI() {
        view.addSubview(topView)
        topView.anchor(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, height: 350)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        listCurrencyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let listCurrencyCollectionView = listCurrencyCollectionView else { return }
        listCurrencyCollectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.identifire)
        listCurrencyCollectionView.delegate = self
        listCurrencyCollectionView.dataSource = self
        listCurrencyCollectionView.layer.cornerRadius = 30
        view.addSubview(listCurrencyCollectionView)
        
        listCurrencyCollectionView.anchor(left: view.leftAnchor, top: topView.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, paddingTop: -15)
    }
}

//  MARK: - Extension

extension ExchangeRateController: UICollectionViewDelegate {
    
}

extension ExchangeRateController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.identifire, for: indexPath) as? CurrencyCell else { return UICollectionViewCell() }
        
        return cell
    }
}

extension ExchangeRateController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
}
