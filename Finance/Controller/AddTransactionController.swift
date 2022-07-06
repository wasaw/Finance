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
    private var addTransaction = LastTransaction()
    
    private let datePicker = UIDatePicker()
    private var isRevenue = false
    private let savedImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "savings.png")
        return img
    }()

//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ammountView.delegate = self
        loadInformation()
        configureUI()
        setDate()
        
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
        configureSavedView()
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
        revenueView.delegate = self
        revenueView.anchor(left: view.leftAnchor, top: categoryCollectionView!.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingRight: -20, height: 20)
    }
    
    private func configureAmmountView() {
        view.addSubview(ammountView)
        ammountView.anchor(left: view.leftAnchor, top: revenueView.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingTop: 10, paddingRight: -10, height: 370)
    }
    
    private func configureSavedView() {
        view.addSubview(savedImage)
        savedImage.anchor(width: 250, height: 250)
        savedImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        savedImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        savedImage.layer.opacity = 0
    }
    
    private func setDate() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        
        ammountView.setDateConfiguration(datePicket: datePicker, toolBar: toolBar)
    }
    
//    MARK: - Selectors
    
    @objc private func doneAction() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        ammountView.setDateInformation(date: formatter.string(from: datePicker.date))
        addTransaction.date = datePicker.date
        view.endEditing(true)
    }
    
    @objc private func cancelAction() {
        view.endEditing(true)
    }
}

//  MARK: - Extensions

extension AddTransactionController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.typeCollectionView {
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
                addTransaction.img = category[indexPath.row].img
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
        addTransaction.ammount = isRevenue ? ammount : -1 * ammount
        addTransaction.comment = comment
        if databaseService.saveTransaction(transaction: addTransaction) {
            UIView.animate(withDuration: 1.75, delay: 0, options: []) {
                self.savedImage.layer.opacity = 1
            } completion: { _ in
                for i in 0..<self.revenue.count {
                    self.revenue[i].isChecked = false
                }
                for i in 0..<self.category.count {
                    self.category[i].isChecked = false
                }
                self.typeCollectionView?.reloadData()
                self.categoryCollectionView?.reloadData()
                self.revenueView.turnOffSwitcher()
                self.ammountView.refreshInformation()
                UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.savedImage.layer.opacity = 0
                }, completion: nil)
            }
        }
    }
}

extension AddTransactionController: SwitcherValueDelegate {
    func switchChanged(value: Bool) {
        isRevenue = value
    }
}
