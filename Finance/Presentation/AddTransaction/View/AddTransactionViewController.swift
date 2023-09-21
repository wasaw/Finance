//
//  AddTransactionViewController.swift
//  Finance
//
//  Created by Александр Меренков on 16.06.2023.
//

import UIKit

private enum Constants {
    static let horizontalPadding: CGFloat = 10
    static let paddingTop: CGFloat = 10
    static let paddingTopContent: CGFloat = 20
    static let scrollViewHeight: CGFloat = 830
    static let typeCollectionViewHeight: CGFloat = 90
    static let categoryCollectionViewHeight: CGFloat = 135
    static let revenueViewHeight: CGFloat = 20
    static let typeCollectionItemHeight: CGFloat = 80
    static let collectionItemWidth: CGFloat = 90
    static let categoryCollectionItemHeight: CGFloat = 60
    static let collectionViewLayoutHorizontal: CGFloat = 5
    static let collectionViewLayoutVertical: CGFloat = 2
    static let titleHeight: CGFloat = 20
    static let textFieldHeight: CGFloat = 40
    static let paddingTopTwentyFive: CGFloat = 25
    static let doneButtonHeight: CGFloat = 80
    static let switchTitleTop: CGFloat = 5
}

final class AddTransactionViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: AddTransactionOutput
    private let revenueAdapter = RevenueAdaper()
    private let categoryAdapter = CategoryAdapter()
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var revenueTitleView = TitleView()
    private var revenueCollectionView: UICollectionView?
    
    private lazy var categoryTitleView = TitleView()
    private var categoryCollectionView: UICollectionView?
    
    private lazy var switcher: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        sw.addTarget(self, action: #selector(tapSwitcher), for: .valueChanged)
        return sw
    }()
    private let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Доход"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    private lazy var amountTitle = TitleView()
    private lazy var amountTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Сумма"
        tf.keyboardType = .asciiCapableNumberPad
        tf.textColor = .black
        return tf
    }()
    private lazy var dateTitle = TitleView()
    private lazy var dateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Дата"
        tf.textColor = .black
        return tf
    }()
    private lazy var commentTitle = TitleView()
    private lazy var commentTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Комментарий"
        tf.textColor = .black
        tf.returnKeyType = .done
        return tf
    }()
    private lazy var doneButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Готово", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 27)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 20
        btn.backgroundColor = .systemGreen
        btn.addTarget(self, action: #selector(handleDoneButton), for: .touchUpInside)
        return btn
    }()
    
    private let datePicker = UIDatePicker()
    
    // MARK: - Lifecycle
    
    init(output: AddTransactionOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        amountTextField.addLine()
        commentTextField.addLine()
        dateTextField.addLine()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        contentView.backgroundColor = .white
        view.backgroundColor = .white
        setDate()
        output.viewIsReady()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        configureScrollView()
        configureRevenueTitleView()
        configureRevenueCollectionView()
        configureCategoryTitleView()
        configureCategoryCollectionView()
        configureSwitcher()
        configureAmountView()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.anchor(leading: view.leadingAnchor,
                          top: view.topAnchor,
                          trailing: view.trailingAnchor,
                          bottom: view.bottomAnchor)
        
        scrollView.addSubview(contentView)
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.anchor(leading: scrollView.leadingAnchor,
                           top: scrollView.topAnchor,
                           trailing: scrollView.trailingAnchor,
                           bottom: scrollView.bottomAnchor,
                           height: Constants.scrollViewHeight)
    }
    
    private func configureRevenueTitleView() {
        contentView.addSubview(revenueTitleView)
        revenueTitleView.anchor(leading: contentView.leadingAnchor,
                                top: contentView.topAnchor,
                                trailing: contentView.trailingAnchor,
                                paddingLeading: Constants.horizontalPadding,
                                paddingTop: Constants.paddingTopContent,
                                paddingTrailing: -Constants.horizontalPadding,
                                height: Constants.titleHeight)
        revenueTitleView.setTitle(title: "Выбрать тип дохода")
    }
    
    private func configureRevenueCollectionView() {
        let revenueLayout = UICollectionViewFlowLayout()
        revenueLayout.scrollDirection = .horizontal
        revenueCollectionView = UICollectionView(frame: .zero, collectionViewLayout: revenueLayout)
        guard let revenueCollectionView = revenueCollectionView else { return }
        revenueCollectionView.register(RevenueCell.self, forCellWithReuseIdentifier: RevenueCell.identifire)
        revenueCollectionView.delegate = self
        revenueCollectionView.dataSource = revenueAdapter
        revenueCollectionView.showsHorizontalScrollIndicator = false
        revenueCollectionView.backgroundColor = .white
        contentView.addSubview(revenueCollectionView)
        revenueCollectionView.anchor(leading: contentView.leadingAnchor,
                                     top: revenueTitleView.bottomAnchor,
                                     trailing: contentView.trailingAnchor,
                                     paddingLeading: Constants.horizontalPadding,
                                     paddingTop: Constants.paddingTop,
                                     paddingTrailing: -Constants.horizontalPadding,
                                     height: Constants.typeCollectionViewHeight)
    }
    
    private func configureCategoryTitleView() {
        contentView.addSubview(categoryTitleView)
        guard let typeCollectionView = revenueCollectionView else { return }
        categoryTitleView.anchor(leading: contentView.leadingAnchor,
                                 top: typeCollectionView.bottomAnchor,
                                 trailing: contentView.trailingAnchor,
                                 paddingLeading: Constants.horizontalPadding,
                                 paddingTop: Constants.paddingTop,
                                 paddingTrailing: -Constants.horizontalPadding,
                                 height: Constants.titleHeight)
        categoryTitleView.setTitle(title: "Выбрать категорию трат")
    }
    
    private func configureCategoryCollectionView() {
        let categoryLayout = UICollectionViewFlowLayout()
        categoryLayout.scrollDirection = .horizontal
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout)
        guard let categotyCollectionView = categoryCollectionView else { return }
        categotyCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifire)
        categotyCollectionView.delegate = self
        categotyCollectionView.dataSource = categoryAdapter
        categotyCollectionView.showsHorizontalScrollIndicator = false
        categotyCollectionView.backgroundColor = .white
        contentView.addSubview(categotyCollectionView)
        categotyCollectionView.anchor(leading: contentView.leadingAnchor,
                                      top: categoryTitleView.bottomAnchor,
                                      trailing: contentView.trailingAnchor,
                                      paddingLeading: Constants.horizontalPadding,
                                      paddingTop: Constants.paddingTop,
                                      paddingTrailing: -Constants.horizontalPadding,
                                      height: Constants.categoryCollectionViewHeight)
    }
    
    private func configureSwitcher() {
        contentView.addSubview(switcher)
        switcher.anchor(leading: contentView.leadingAnchor,
                        top: categoryCollectionView?.bottomAnchor,
                        paddingLeading: Constants.horizontalPadding,
                        paddingTop: Constants.paddingTop,
                        height: Constants.revenueViewHeight)
        
        contentView.addSubview(textLabel)
        textLabel.anchor(leading: switcher.trailingAnchor,
                         paddingLeading: Constants.horizontalPadding)
        textLabel.centerYAnchor.constraint(equalTo: switcher.centerYAnchor,
                                           constant: Constants.switchTitleTop).isActive = true
    }
    
    private func configureAmountView() {
        contentView.addSubview(amountTitle)
        amountTitle.anchor(leading: contentView.leadingAnchor,
                           top: switcher.bottomAnchor,
                           trailing: contentView.trailingAnchor,
                           paddingLeading: Constants.horizontalPadding,
                           paddingTop: Constants.titleHeight,
                           paddingTrailing: -Constants.horizontalPadding,
                           height: Constants.titleHeight)
        amountTitle.setTitle(title: "Сумма")
        contentView.addSubview(amountTextField)
        amountTextField.anchor(leading: contentView.leadingAnchor,
                               top: amountTitle.bottomAnchor,
                               trailing: contentView.trailingAnchor,
                               paddingLeading: Constants.horizontalPadding,
                               paddingTop: Constants.paddingTop,
                               paddingTrailing: -Constants.horizontalPadding,
                               height: Constants.textFieldHeight)
        
        contentView.addSubview(dateTitle)
        dateTitle.anchor(leading: contentView.leadingAnchor,
                         top: amountTextField.bottomAnchor,
                         trailing: contentView.trailingAnchor,
                         paddingLeading: Constants.horizontalPadding,
                         paddingTop: Constants.paddingTopTwentyFive,
                         paddingTrailing: -Constants.horizontalPadding,
                         height: Constants.titleHeight)
        dateTitle.setTitle(title: "Дата")
        contentView.addSubview(dateTextField)
        dateTextField.anchor(leading: contentView.leadingAnchor,
                             top: dateTitle.bottomAnchor,
                             trailing: contentView.trailingAnchor,
                             paddingLeading: Constants.horizontalPadding,
                             paddingTop: Constants.paddingTop,
                             paddingTrailing: -Constants.horizontalPadding,
                             height: Constants.textFieldHeight)
        
        contentView.addSubview(commentTitle)
        commentTitle.anchor(leading: contentView.leadingAnchor,
                            top: dateTextField.bottomAnchor,
                            trailing: contentView.trailingAnchor,
                            paddingLeading: Constants.horizontalPadding,
                            paddingTop: Constants.paddingTopTwentyFive,
                            paddingTrailing: -Constants.horizontalPadding,
                            height: Constants.titleHeight)
        commentTitle.setTitle(title: "Комментарий")
        contentView.addSubview(commentTextField)
        commentTextField.anchor(leading: contentView.leadingAnchor,
                                top: commentTitle.bottomAnchor,
                                trailing: contentView.trailingAnchor,
                                paddingLeading: Constants.horizontalPadding,
                                paddingTop: Constants.paddingTop,
                                paddingTrailing: -Constants.horizontalPadding,
                                height: Constants.textFieldHeight)
        
        contentView.addSubview(doneButton)
        doneButton.anchor(leading: contentView.leadingAnchor,
                          top: commentTextField.bottomAnchor,
                          trailing: contentView.trailingAnchor,
                          paddingLeading: Constants.horizontalPadding,
                          paddingTop: Constants.paddingTopTwentyFive,
                          paddingTrailing: -Constants.horizontalPadding,
                          height: Constants.doneButtonHeight)
        configureKeyboard()
    }
    
    private func configureKeyboard() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(cancelAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        amountTextField.inputAccessoryView = toolBar
        commentTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setDate() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        toolBar.sizeToFit()
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolBar
    }
    
    // MARK: - Selectors
    
    @objc private func doneAction() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc private func cancelAction() {
        view.endEditing(true)
    }
    
    @objc private func handleDoneButton() {
        output.saveTransaction(SaveTransaction(amount: amountTextField.text,
                                               date: datePicker.date,
                                               comment: commentTextField.text))
    }
    
    @objc private func tapSwitcher(sender: UISwitch) {
        output.isRevenue(switcher.isOn)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if commentTextField.isFirstResponder {
                scrollView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height), animated: true)
            }
        }
    }
}

// MARK: - AddTransactionInput

extension AddTransactionViewController: AddTransactionInput {
    func showData(category: [ChoiceCategoryExpense],
                  revenue: [ChoiceTypeRevenue],
                  currency: Currency,
                  currencyRate: Double) {
        revenueAdapter.configure(RevenueCellValues(revenue: revenue, currency: currency, currencyRate: currencyRate))
        categoryAdapter.configure(CategoryCellValues(category: category, currency: currency, currencyRate: currencyRate))
        revenueCollectionView?.reloadData()
        categoryCollectionView?.reloadData()
    }
    
    func dismissView() {
        self.dismiss(animated: true)
    }
    
    func showAlert(with title: String, and text: String) {
        self.alert(with: title, message: text)
    }
}

// MARK: - UICollectionViewDelegate

extension AddTransactionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.revenueCollectionView {
            revenueAdapter.setSelected(at: indexPath.row)
            output.selectedRevenue(indexPath.row)
            collectionView.reloadData()
        }
        if collectionView == self.categoryCollectionView {
            categoryAdapter.setSelected(at: indexPath.row)
            output.selectedCategory(indexPath.row)
            collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AddTransactionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.revenueCollectionView {
            return CGSize(width: Constants.collectionItemWidth,
                          height: Constants.typeCollectionItemHeight)
        }
        return CGSize(width: Constants.collectionItemWidth,
                      height: Constants.categoryCollectionItemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.collectionViewLayoutVertical,
                            left: Constants.collectionViewLayoutHorizontal,
                            bottom: Constants.collectionViewLayoutVertical,
                            right: Constants.collectionViewLayoutHorizontal)
    }
}

// MARK: - UITextFieldDelegate

extension AddTransactionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if commentTextField.isFirstResponder {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        commentTextField.resignFirstResponder()
        return true
    }
}
