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
    static let accountCollectionViewHeight: CGFloat = 90
    static let categoryCollectionViewHeight: CGFloat = 135
    static let accountCollectionItemHeight: CGFloat = 80
    static let collectionItemWidth: CGFloat = 90
    static let categoryCollectionItemHeight: CGFloat = 60
    static let collectionViewLayoutHorizontal: CGFloat = 5
    static let collectionViewLayoutVertical: CGFloat = 2
    static let titleHeight: CGFloat = 20
    static let textFieldHeight: CGFloat = 40
    static let paddingTopTwentyFive: CGFloat = 25
    static let doneButtonHeight: CGFloat = 80
    static let switcherHidePaddingTop: CGFloat = 120
    static let switcherPaddingTop: CGFloat = 310
    static let switchTitleTop: CGFloat = 3
}

final class AddTransactionViewController: UIViewController {
    
// MARK: - Properties
    
    private let output: AddTransactionOutput
    private let accountAdapter = AccountAdaper()
    private let categoryAdapter = CategoryAdapter()
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    
    private lazy var accountTitleView = TitleView()
    private var accountCollectionView: UICollectionView?
    
    private lazy var categoryTitleView = TitleView()
    private var categoryCollectionView: UICollectionView?
    
    private lazy var switcher: UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        sw.addTarget(self, action: #selector(tapSwitcher), for: .valueChanged)
        return sw
    }()
    private lazy var switcherLabel: UILabel = {
        let label = UILabel()
        label.text = "Доход"
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textColor = .totalTintColor
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
    private var switcherTopContraint: NSLayoutConstraint?
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        configureScrollView()
        configureAccountTitleView()
        configureAccountCollectionView()
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
    
    private func configureAccountTitleView() {
        contentView.addSubview(accountTitleView)
        accountTitleView.anchor(leading: contentView.leadingAnchor,
                                top: contentView.topAnchor,
                                trailing: contentView.trailingAnchor,
                                paddingLeading: Constants.horizontalPadding,
                                paddingTop: Constants.paddingTopContent,
                                paddingTrailing: -Constants.horizontalPadding,
                                height: Constants.titleHeight)
        accountTitleView.setTitle(title: "Выбрать счет")
    }
    
    private func configureAccountCollectionView() {
        let accountLayout = UICollectionViewFlowLayout()
        accountLayout.scrollDirection = .horizontal
        accountCollectionView = UICollectionView(frame: .zero, collectionViewLayout: accountLayout)
        guard let accountCollectionView = accountCollectionView else { return }
        accountCollectionView.register(AccountCell.self, forCellWithReuseIdentifier: AccountCell.identifire)
        accountCollectionView.delegate = self
        accountCollectionView.dataSource = accountAdapter
        accountCollectionView.showsHorizontalScrollIndicator = false
        accountCollectionView.backgroundColor = .white
        contentView.addSubview(accountCollectionView)
        accountCollectionView.anchor(leading: contentView.leadingAnchor,
                                     top: accountTitleView.bottomAnchor,
                                     trailing: contentView.trailingAnchor,
                                     paddingLeading: Constants.horizontalPadding,
                                     paddingTop: Constants.paddingTop,
                                     paddingTrailing: -Constants.horizontalPadding,
                                     height: Constants.accountCollectionViewHeight)
    }
    
    private func configureCategoryTitleView() {
        contentView.addSubview(categoryTitleView)
        guard let typeCollectionView = accountCollectionView else { return }
        categoryTitleView.anchor(leading: contentView.leadingAnchor,
                                 top: typeCollectionView.bottomAnchor,
                                 trailing: contentView.trailingAnchor,
                                 paddingLeading: Constants.horizontalPadding,
                                 paddingTop: Constants.paddingTop,
                                 paddingTrailing: -Constants.horizontalPadding,
                                 height: Constants.titleHeight)
        categoryTitleView.setTitle(title: "Выбрать категорию")
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
        contentView.addSubview(switcherLabel)
        switcherLabel.anchor(leading: contentView.leadingAnchor,
                        paddingLeading: Constants.horizontalPadding)
        switcherTopContraint = switcherLabel.topAnchor.constraint(equalTo: accountTitleView.bottomAnchor, constant: Constants.switcherPaddingTop)
        switcherTopContraint?.isActive = true
        
        contentView.addSubview(switcher)
        switcher.anchor(leading: switcherLabel.trailingAnchor,
                         paddingLeading: Constants.horizontalPadding)
        switcher.centerYAnchor.constraint(equalTo: switcherLabel.centerYAnchor,
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
        if sender.isOn {
            UIView.animate(withDuration: 0.4, delay: 0) {
                self.categoryTitleView.alpha = 0
                self.categoryCollectionView?.alpha = 0
                self.switcherTopContraint?.constant = Constants.switcherHidePaddingTop
                self.view.layer.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.4, delay: 0) {
                self.categoryTitleView.alpha = 1
                self.categoryCollectionView?.alpha = 1
                self.switcherTopContraint?.constant = Constants.switcherPaddingTop
                self.view.layer.layoutIfNeeded()
            }
        }
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
    func setAccount(_ account: [AccountCellModel]) {
        accountAdapter.configure(account)
    }
    
    func setCategory(_ categories: [CategoryCellModel]) {
        categoryAdapter.configure(categories)
    }
    
    func showData(category: [ChoiceCategoryExpense],
                  revenue: [ChoiceTypeRevenue],
                  currency: Currency,
                  currencyRate: Double) {
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
        if collectionView == self.accountCollectionView {
            accountAdapter.setSelected(at: indexPath.row)
            output.selectedAccount(indexPath.row)
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
        if collectionView == self.accountCollectionView {
            return CGSize(width: Constants.collectionItemWidth,
                          height: Constants.accountCollectionItemHeight)
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
