//
//  CategoryAdapter.swift
//  Finance
//
//  Created by Александр Меренков on 28.08.2023.
//

import UIKit

final class CategoryAdapter: NSObject {
    
// MARK: - Properties
    
    private var categories = [CategoryCellModel]()
    private var isSelected = 0
    
// MARK: - Helpers
    
    func configure(_ categories: [CategoryCellModel]) {
        self.categories = categories
    }
    
    func setSelected(at index: Int) {
        isSelected = index
    }
}

// MARK: - UICollectionViewDataSource

extension CategoryAdapter: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifire,
                                                            for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        let currentCategory = categories[indexPath.row]
        guard let image = UIImage(data: currentCategory.imageData) else { return UICollectionViewCell() }
        cell.setInfornation(title: currentCategory.title, image: image)
        cell.disableSelect()
        if isSelected == indexPath.row {
            cell.setSelect()
        }
        return cell
    }
}
