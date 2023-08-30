//
//  RevenueAdapter.swift
//  Finance
//
//  Created by Александр Меренков on 28.08.2023.
//

import UIKit

struct RevenueCellValues {
    let revenue: [ChoiceTypeRevenue]
    let currency: Currency
    let currencyRate: Double
}

final class RevenueAdaper: NSObject {
    
// MARK: - Properties
    
    private var revenue = [ChoiceTypeRevenue]()
    private var currency: Currency = .rub
    private var currencyRate = 1.0
    private var isSelected = 0

// MARK: - Helpers
    
    func configure(_ typeCellValues: RevenueCellValues) {
        self.revenue = typeCellValues.revenue
        self.currency = typeCellValues.currency
        self.currencyRate = typeCellValues.currencyRate
    }
    
    func setSelected(at index: Int) {
        isSelected = index
    }
}

// MARK: - UICollectionViewDataSource

extension RevenueAdaper: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return revenue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RevenueCell.identifire,
                                                            for: indexPath) as? RevenueCell else { return UICollectionViewCell() }
        let currentRevenue = revenue[indexPath.row]
        let amount = currentRevenue.amount / currencyRate
        cell.setInfornation(title: currentRevenue.name, img: currentRevenue.img, amount: amount, currency: currency)
        cell.disableSelect()
        if isSelected == indexPath.row {
            cell.setSelect()
        }
        return cell
    }
}
