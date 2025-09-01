//
//  BookViewController.swift
//  ReadBook
//
//  Created by Кристина Олейник on 21.08.2025.
//

import UIKit
import SnapKit

final class BookViewController: UIViewController {
    //MARK: - GUI Variables
    
    //MARK: Scroll
    private let scrollView = UIScrollView()
    
    private let contentView: UIView = UIView()
    
    //MARK: StackView
    private let informationStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private let buttonsStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        return view
    }()
    
    private let contentLibraryStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    //MARK: View
    //image
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "mock")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let editCoverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Cover", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkBord
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    private let titleView = UIView()
    
    private let authorView = UIView()
    
    private let publisherView = UIView()
    
    private let pageView = UIView()
    
    private let descriptionView = UIView()
    
    private let startDateView = UIView()
    
    private let endDateView = UIView()
    
    private let ratingView = UIView()
    
    private let commentView = UIView()
    
    //MARK: Buttons
    private let wishListButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("WishList", for: .normal)
        
        return button
    }()
    
    private let libraryButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Library", for: .normal)
        
        return button
    }()
    
    //MARK: Labels and Text Fields
    
    //Title
    private lazy var titleLabel = makeLabel(text: "Title")
    
    private let titleTextField = UITextField()
    
    //Author
    private lazy var authorLabel = makeLabel(text: "Author")
    
    private let authorTextField = UITextField()
    
    //publisher
    private lazy var publisherLabel = makeLabel(text: "Publisher")
    
    private let publisherTextField = UITextField()
    
    //pages
    private lazy var pagesLabel = makeLabel(text: "Page")
    
    private let pagesTextField = UITextField()
    
    //description
    private lazy var descriptionLabel = makeLabel(text: "Description")
    
    private let descriptionTextView = UITextView()
    
    
    //startDate
    private lazy var startDateLabel = makeLabel(text: "Start date:")
    
    private let startDateTextField = UITextField()
    
    //endDate
    private lazy var endDateLabel = makeLabel(text: "End date:")
    
    private let endDateTextField = UITextField()
    
    //rating
    private lazy var ratingLabel = makeLabel(text: "Rating:")
    
    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    //comment
    private lazy var commentLabel = makeLabel(text: "Comment:")
    
    private let commentTextView = UITextView()
    
    //MARK: - Properties
    var viewModel: BookViewModelProtocol?
    private weak var activeField: UIView?
    
    private let heightTextField = 30
    private let cornerRadiusTextField: CGFloat = 8
    private var starButtons: [UIButton] = []
    
    private var startDate: Date? {
        didSet {
            if let date = startDate {
                startDateTextField.text = dateFormatter.string(from: date)
            } else {
                startDateTextField.text = nil
            }
        }
    }
    private var endDate: Date? {
        didSet {
            if let date = endDate {
                endDateTextField.text = dateFormatter.string(from: date)
            } else {
                endDateTextField.text = nil
            }
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupUI()
        setDelegate()
        setupGesture()
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        unregisterForKeyboardNotification()
    }
    //MARK: - Private Methods
    
    
    
    //MARK: Delegate and configure
    private func setDelegate() {
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        titleTextField.delegate = self
        authorTextField.delegate = self
        publisherTextField.delegate = self
        pagesTextField.delegate = self
        
        descriptionTextView.delegate = self
        commentTextView.delegate = self
    }
    
    private func configure() {
        titleTextField.text = viewModel?.book?.title
        authorTextField.text = viewModel?.book?.author
        publisherTextField.text = viewModel?.book?.publisher
        
        if let pages = viewModel?.book?.pages {
            pagesTextField.text = pages == 0 ? "" : String(pages)
        }
        
        descriptionTextView.text = viewModel?.book?.description
        startDate = viewModel?.book?.startDate
        endDate = viewModel?.book?.endDate
        commentTextView.text = viewModel?.book?.comment
        coverImageView.image = viewModel?.getCoverImage()
    }
    
    private func setupUI() {
        view.backgroundColor = .background
        setupSubview()
        setupConstraints()
        configureButtons()
        setupEditCoverButton()
        setupTextFields()
        setupRatingView()
        setupDatePickers()
        updateStars()
        
        if viewModel?.typeBook == .library {
            updateLibraryStackView(isHide: false)
            wishListButton.isHidden = true
            libraryButton.isHidden = true
        } else {
            updateLibraryStackView(isHide: true)
            //wishListButton.isHidden = true
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveAction)
        )
    }
    
    //MARK: Save
    @objc
    private func saveAction() {
        view.endEditing(true)
        if titleTextField.text == "" {
            let message = "Title can't be empty"
            AlertManager.showAlert(on: self,
                                   message: message)
        } else if authorTextField.text == "" {
            let message = "Author can't be empty"
            AlertManager.showAlert(on: self,
                                   message: message)
        } else if viewModel?.typeBook == .library && endDateTextField.text == "" {
            let message = "End date can't be empty"
            AlertManager.showAlert(on: self,
                                   message: message)
        } else if let start = startDate,
                  let end = endDate,
                  start > end {
            let message = "Start date can't be after end date"
            AlertManager.showAlert(on: self,
                                   message: message)
        } else if viewModel?.currentRating == 0 && viewModel?.typeBook == .library {
            let message = "Please rate the book :)"
            AlertManager.showAlert(on: self,
                                   message: message)
        } else {
            viewModel?.save(title: titleTextField.text ?? "",
                            author: authorTextField.text ?? "",
                            publisher: publisherTextField.text,
                            description: descriptionTextView.text,
                            pages: Int(pagesTextField.text ?? ""),
                            startDate: startDate,
                            endDate: endDate,
                            comment: commentTextView.text ?? "")
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    @objc
    private func scrollToComment() {
        scrollView.layoutIfNeeded()
        //получаем frame commentView в координатах scrollView
        let targetFrame = commentView.convert(commentView.bounds, to: scrollView)
        scrollView.scrollRectToVisible(targetFrame, animated: true)
    }
}


//MARK: - UITextFieldDelegate
extension BookViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        if textField == startDateTextField || textField == endDateTextField {
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

//MARK: - UITextViewDelegate
extension BookViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
    }
}

//MARK: - UIImagePickerControllerDelegate
extension BookViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel?.setTempImage(selectedImage)
            coverImageView.image = viewModel?.getCoverImage()
        }
        dismiss(animated: true)
    }
    
}

//MARK: - Keyboards events
private extension BookViewController {
    
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_ :)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func unregisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = frame.height
        
        if let active = activeField {
            let frameInScroll = active.convert(active.bounds, to: scrollView)
            scrollView.scrollRectToVisible(frameInScroll, animated: true)
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = .zero
        activeField = nil
    }
    
    private func setupGesture() {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
}


//MARK: - Stars
extension BookViewController {
    private func updateStars() {
        for (index, button) in starButtons.enumerated() {
            let starNumber = index + 1
            if starNumber <= viewModel?.currentRating ?? 0 {
                button.setTitle("★", for: .normal)
            } else {
                button.setTitle("☆", for: .normal)
            }
        }
    }
    
    private func setupRatingView() {
        for i in 1...5 {
            let button = UIButton(type: .system)
            button.tag = i
            button.setTitle("☆", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            button.setTitleColor(.darkBord, for: .normal)
            button.addTarget(self, action: #selector(handleStarTap(_:)), for: .touchUpInside)
            
            starButtons.append(button)
            ratingStackView.addArrangedSubview(button)
        }
    }
    
    @objc
    private func handleStarTap(_ sender: UIButton) {
        if let _ = viewModel?.currentRating {
            viewModel?.currentRating = sender.tag
            updateStars()
        }
    }
}


//MARK: - Date Picker
extension BookViewController {
    private func setupDatePickers() {
        setupDatePicker(for: startDateTextField, selector: #selector(donePressedStart))
        setupDatePicker(for: endDateTextField, selector: #selector(donePressedEnd))
    }
    
    private func setupDatePicker(for textField: UITextField, selector: Selector) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        
        if let text = textField.text,
           let date = dateFormatter.date(from: text) {
            datePicker.date = date
        } else {
            datePicker.date = Date()
        }
        
        textField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel",
                                           style: .done,
                                           target: self,
                                           action: #selector(cancelDatePicker))
        
        let okButton = UIBarButtonItem(title: "OK",
                                       style: .done,
                                       target: self,
                                       action: selector)
        
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        toolbar.setItems([cancelButton, spacing, okButton], animated: true)
        
        textField.inputAccessoryView = toolbar
    }
    
    @objc
    private func cancelDatePicker() {
        view.endEditing(true)
    }
    
    @objc
    private func donePressedStart() {
        if let picker = startDateTextField.inputView as? UIDatePicker {
            let date = picker.date
            startDateTextField.text = dateFormatter.string(from: date)
            startDate = date
        }
        view.endEditing(true)
    }
    
    @objc
    private func donePressedEnd() {
        if let picker = endDateTextField.inputView as? UIDatePicker {
            let date = picker.date
            endDateTextField.text = dateFormatter.string(from: date)
            endDate = date
        }
        view.endEditing(true)
    }
}


//MARK: - image
extension BookViewController {
    private func setupEditCoverButton() {
        editCoverButton.addTarget(self, action: #selector(editCoverTapped), for: .touchUpInside)
    }
    
    @objc
    private func editCoverTapped() {
        
        var actions: [UIAlertAction] = []
        
        actions.append(UIAlertAction(title: "Загрузить из галереи",
                                     style: .default) { _ in
            self.openImagePicker()
        })
        
        //delete if image not mock
        if let currentImage = viewModel?.getCoverImage(),
           currentImage != UIImage(named: "mock") {
            actions.append(UIAlertAction(title: "Удалить обложку",
                                         style: .destructive) { _ in
                self.viewModel?.markImageForDeletion()
                self.coverImageView.image = self.viewModel?.getCoverImage()
            })
        }
        
        
        AlertManager.showActionShit(on: self,
                                    title: "Обложка",
                                    actions: actions)
    }
    
    private func openImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}


//MARK: - Setup Buttons
extension BookViewController {
    private func configureButtons() {
        //изначально выбран WishList
        if viewModel?.typeBook == .library {
            libraryButton.isSelected = true
        } else {
            wishListButton.isSelected = true
        }
        updateButtonAppearance(wishListButton)
        updateButtonAppearance(libraryButton)
        
        [wishListButton, libraryButton].forEach { button in
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            button.setTitleColor(.textColor, for: .normal)
            button.setTitleColor(.background, for: .selected)
            
            button.addTarget(self, action: #selector(handleButtonTap(_:)), for: .touchUpInside)
        }
        libraryButton.addTarget(self, action: #selector(scrollToComment), for: .touchUpInside)
    }
    
    @objc
    private func handleButtonTap(_ sender: UIButton) {
        [wishListButton, libraryButton].forEach {
            $0.isSelected = false
            updateButtonAppearance($0)
        }
        
        sender.isSelected.toggle()
        updateButtonAppearance(sender)
        updateLibraryStackView(isHide: !libraryButton.isSelected)
    }
    
    private func updateButtonAppearance(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = .darkBord
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .secondBG
            button.setTitleColor(.black, for: .normal)
        }
    }
    
    private func updateLibraryStackView(isHide: Bool) {
        startDateView.isHidden = isHide
        endDateView.isHidden = isHide
        ratingView.isHidden = isHide
        commentView.isHidden = isHide
        
        viewModel?.typeBook = isHide ? .wishlist : .library
    }
}


//MARK: - Setup (add subview, constraints etc)
extension BookViewController {
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .textColor
        return label
    }
    
    private func setupTextFields() {
        [titleTextField,
         authorTextField,
         publisherTextField,
         pagesTextField,
         descriptionTextView,
         startDateTextField,
         endDateTextField,
         commentTextView].forEach { view in
            view.layer.cornerRadius = cornerRadiusTextField
            view.backgroundColor = .secondBG
            
            if let textField = view as? UITextField {
                textField.font = .systemFont(ofSize: 16, weight: .regular)
                textField.textColor = .textColor
            } else if let textView = view as? UITextView {
                textView.font = .systemFont(ofSize: 16, weight: .regular)
                textView.textColor = .textColor
            }
        }
    }
    
    private func setupSubview() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews([coverImageView,
                                 editCoverButton,
                                 informationStackView,
                                 buttonsStackView,
                                 contentLibraryStackView])
        
        informationStackView.addArrangedSubviews([titleView,
                                                  authorView,
                                                  publisherView,
                                                  pageView,
                                                  descriptionView])
        
        buttonsStackView.addArrangedSubviews([wishListButton,
                                              libraryButton])
        
        contentLibraryStackView.addArrangedSubviews([startDateView,
                                                     endDateView,
                                                     ratingView,
                                                     commentView])
        
        addField(to: titleView, label: titleLabel, field: titleTextField)
        addField(to: authorView, label: authorLabel, field: authorTextField)
        addField(to: publisherView, label: publisherLabel, field: publisherTextField)
        addField(to: pageView, label: pagesLabel, field: pagesTextField)
        addField(to: descriptionView, label: descriptionLabel, field: descriptionTextView, fieldHeight: 100)
        addField(to: startDateView, label: startDateLabel, field: startDateTextField)
        addField(to: endDateView, label: endDateLabel, field: endDateTextField)
        addField(to: ratingView, label: ratingLabel, field: ratingStackView, fieldHeight: 40)
        addField(to: commentView, label: commentLabel, field: commentTextView, fieldHeight: 100)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.5)
        }
        
        editCoverButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(coverImageView.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(60)
            make.height.equalTo(30)
        }
        
        informationStackView.snp.makeConstraints { make in
            make.top.equalTo(editCoverButton.snp.bottom).offset(10)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(informationStackView.snp.bottom).offset(30)
            make.trailing.leading.equalToSuperview().inset(20)
            //make.bottom.equalToSuperview().inset(20)
        }
        
        contentLibraryStackView.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(30)
            make.trailing.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        wishListButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        libraryButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    private func addField(to container: UIView,
                          label: UILabel,
                          field: UIView,
                          fieldHeight: CGFloat? = nil) {
        container.addSubviews([label, field])
        
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(heightTextField)
        }
        
        field.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            if let h = fieldHeight {
                make.height.equalTo(h)
            } else {
                make.height.equalTo(heightTextField)
            }
        }
    }
    
}


