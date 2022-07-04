//
//  AddTransactionController.swift
//  Finance
//
//  Created by Александр Меренков on 17.06.2022.
//

import UIKit

class AddTransactionController: UIViewController {
    
//    MARK: - Properties
        
    private let typeTitleView = TitleView()
    private var typeCollectionView: UICollectionView?
    
    private let categoryTitleView = TitleView()
    private var categoryCollectionView: UICollectionView?
    
    private let revenueView = RevenueView()
    private let ammountView = AmmountView()
    
    private let databaseService = DatabaseService.shared
    private var category = [ChoiceCategoryExpense]() {
        didSet {
            categoryCollectionView?.reloadData()
        }
    }
    private var revenue = [ChoiceTypeRevenue]() {
        didSet {
            typeCollectionView?.reloadData()
        }
    }
    private var isCheckedType = false
    private var isCheckedCategory = false
    private var addTransaction = LastTransaction(type: "", ammount: 0, comment: "", category: "")

//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ammountView.delegate = self
        loadInformation()
        configureUI()
        
        view.backgroundColor = .white
    }
    
//    MARK: - Helpers
    
    private func loadInformation() {
        DispatchQueue.main.async {
            self.category = self.databaseService.getCategoryInformation()
            self.revenue = self.databaseService.getTypeInformation()
        }
    }
    
    private func configureUI() {
        configureTypeTitleView()
        configureTypeCollectionView()
        configureCategoryTitleView()
        configureCategoryCollectionView()
        configureRevenueView()
        configureAmmountView()
    }
    
    private func configureTypeTitleView() {
        view.addSubview(typeTitleView)
        let paddingTop: CGFloat = (view.frame.height < 700) ? 30 : 50
        typeTitleView.anchor(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: paddingTop, paddingRight: -10, height: 30)
        typeTitleView.setTitle(title: "Выбрать тип дохода")
    }
    
    private func configureTypeCollectionView() {
        let typeLayout = UICollectionViewFlowLayout()
        typeLayout.scrollDirection = .horizontal
        typeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: typeLayout)
        guard let typeCollectionView = typeCollectionView else { return }
        typeCollectionView.register(AddCell.self, forCellWithReuseIdentifier: AddCell.identifire)
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        typeCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(typeCollectionView)
        typeCollectionView.anchor(left: view.leftAnchor, top: typeTitleView.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, height: 90)
    }
    
    private func configureCategoryTitleView() {
        view.addSubview(categoryTitleView)
        categoryTitleView.anchor(left: view.leftAnchor, top: typeCollectionView!.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 5, paddingRight: -10, height: 30)
        categoryTitleView.setTitle(title: "Выбрать категорию трат")
    }
    
    private func configureCategoryCollectionView() {
        let categoryLayout = UICollectionViewFlowLayout()
        categoryLayout.scrollDirection = .horizontal
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout)
        guard let categotyCollectionView = categoryCollectionView else { return }
        categotyCollectionView.register(AddCell.self, forCellWithReuseIdentifier: AddCell.identifire)
        categotyCollectionView.delegate = self
        categotyCollectionView.dataSource = self
        categotyCollectionView.showsHorizontalScrollIndicator = false
        view.addSubview(categotyCollectionView)
        let height: CGFloat = (view.frame.height < 700) ? 90 : 200
        categotyCollectionView.anchor(left: view.leftAnchor, top: categoryTitleView.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, height: height)
    }
    
    private func configureRevenueView() {
        view.addSubview(revenueView)
        revenueView.anchor(left: view.leftAnchor, top: categoryCollectionView!.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: -20, height: 20)
    }
    
    private func configureAmmountView() {
        view.addSubview(ammountView)
        ammountView.anchor(left: view.leftAnchor, top: revenueView.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, height: 270)
    }
}

//  MARK: - Extensions

extension AddTransactionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.typeCollectionView {
//            guard let _ = collectionView.cellForItem(at: indexPath) as? AddCell else { return }
            if isCheckedType {
                if revenue[indexPath.row].isChecked  {
                    isCheckedType = false
                    revenue[indexPath.row].isChecked = false
                    addTransaction.type = ""
                }
            } else {
                isCheckedType = true
                revenue[indexPath.row].isChecked = true
                addTransaction.type = revenue[indexPath.row].name
            }
        }
        if collectionView == self.categoryCollectionView {
//            guard let _ = collectionView.cellForItem(at: indexPath) as? AddCell else { return }
            if isCheckedCategory {
                if category[indexPath.row].isChecked  {
                    isCheckedCategory = false
                    category[indexPath.row].isChecked = false
                    addTransaction.category = ""
                }
            } else {
                isCheckedCategory = true
                category[indexPath.row].isChecked = true
                addTransaction.category = category[indexPath.row].name
            }
        }
    }
}

extension AddTransactionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.typeCollectionView {
            return revenue.count
        }
        if collectionView == self.categoryCollectionView {
            return category.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.typeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCell.identifire, for: indexPath) as? AddCell else { return UICollectionViewCell() }
            cell.setTitle(revenue[indexPath.row].name)
            cell.setImage(img: revenue[indexPath.row].img)
            if revenue[indexPath.row].isChecked {
                cell.setSelect()
            } else {
                cell.disableSelect()
            }
            return cell
        }
        if collectionView == self.categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCell.identifire, for: indexPath) as? AddCell else { return UICollectionViewCell() }
            cell.setTitle(category[indexPath.row].name)
            cell.setImage(img: category[indexPath.row].img)
            cell.hideCost(true)
            if category[indexPath.row].isChecked {
                cell.setSelect()
            } else {
                cell.disableSelect()
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension AddTransactionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 95)
    }
}

extension AddTransactionController: HandleDoneDelegate {
    func saveInformation(ammount: Int, comment: String) {
        addTransaction.ammount = ammount
        addTransaction.comment = comment
        databaseService.saveTransaction(transaction: addTransaction)
    }
}
