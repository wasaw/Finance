//
//  CategoryAdapter.swift
//  Finance
//
//  Created by Александр Меренков on 28.08.2023.
//

import UIKit

struct CategoryCellValues {
    let category: [ChoiceCategoryExpense]
    let currency: Currency
    let currencyRate: Double
}

final class CategoryAdapter: NSObject {
    
// MARK: - Properties
    
    private var category = [ChoiceCategoryExpense]()
    private var currency: Currency = .rub
    private var currencyRate = 1.0
    private var isSelected = 0
    
// MARK: - Helpers
    
    func configure(_ categoryCellValues: CategoryCellValues) {
        self.category = categoryCellValues.category
        self.currency = categoryCellValues.currency
        self.currencyRate = categoryCellValues.currencyRate
    }
    
    func setSelected(at index: Int) {
        isSelected = index
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifire,
                                                            for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        let currentCategory = category[indexPath.row]
        guard let image = UIImage(named: currentCategory.img) else { return UICollectionViewCell() }
        cell.setInfornation(title: currentCategory.name, image: image, currency: currency)
        cell.disableSelect()
        if isSelected == indexPath.row {
            cell.setSelect()
        }
        return cell
    }
}
