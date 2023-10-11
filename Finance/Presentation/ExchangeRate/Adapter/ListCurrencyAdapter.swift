//
//  ListCurrencyAdapter.swift
//  Finance
//
//  Created by Александр Меренков on 31.08.2023.
//

import UIKit

final class ListCurrencyAdapter: NSObject {
    
// MARK: - Properties
    
    private var exchangeRate = [CurrentExchangeRate]()
    private var currencyRate: Double = 1

// MARK: - Helpers
    
    func configure(_ exchangeRate: [CurrentExchangeRate], rate: Double) {
        self.exchangeRate = exchangeRate
        self.currencyRate = rate
    }
}

// MARK: - UICollectionViewDataSource

extension ListCurrencyAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchangeRate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.identifire,
                                                            for: indexPath) as? CurrencyCell else { return UICollectionViewCell() }
        cell.setInformation(currency: exchangeRate[indexPath.row], rate: currencyRate)
        return cell
    }
}
