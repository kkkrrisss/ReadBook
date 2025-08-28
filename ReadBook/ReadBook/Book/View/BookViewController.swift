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
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //scrollView.translatesAutoresizingMaskIntoConstraints = false
        //scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
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
    
    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let authorView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let publisherView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let pageView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let descriptionView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let startDateView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let endDateView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let commentView: UIView = {
        let view = UIView()
        
        return view
    }()
    
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
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    //Author
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Author"
        return label
    }()
    
    private let authorTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    //publisher
    private let publisherLabel: UILabel = {
        let label = UILabel()
        label.text = "Publisher"
        return label
    }()
    
    
    private let publisherTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    //pages
    private let pagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Page"
        return label
    }()
    
    private let pagesTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    //description
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let view = UITextView()
        return view
    }()
    
    
    //startDate
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Start date:"
        return label
    }()
    
    private let startDateTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    //endDate
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = "End date:"
        return label
    }()
    
    private let endDateTextField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    //rating
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Rating:"
        
        return label
    }()
    
    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    
    //comment
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Comment:"
        
        return label
    }()
    
    private let commentTextView: UITextView = {
        let view = UITextView()
        
        return view
    }()
    
    //MARK: - Properties
    var viewModel: BookViewModelProtocol?
    
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
    }
    
    //MARK: - Private Methods
    
    
    
    //MARK: Setup and configure
    private func setDelegate() {
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        titleTextField.delegate = self
        authorTextField.delegate = self
        publisherTextField.delegate = self
        pagesTextField.delegate = self
    }
    
    private func configure() {
        titleTextField.text = viewModel?.book?.title
        authorTextField.text = viewModel?.book?.author
        publisherTextField.text = viewModel?.book?.publisher
        pagesTextField.text = viewModel?.book?.pages as? String
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
        setupLabels()
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
        
        titleView.addSubviews([titleLabel,
                               titleTextField])
        
        authorView.addSubviews([authorLabel,
                                authorTextField])
        
        publisherView.addSubviews([publisherLabel,
                                   publisherTextField])
        
        pageView.addSubviews([pagesLabel,
                              pagesTextField])
        
        descriptionView.addSubviews([descriptionLabel,
                                     descriptionTextView])
        
        startDateView.addSubviews([startDateLabel,
                                   startDateTextField])
        
        endDateView.addSubviews([endDateLabel,
                                 endDateTextField])
        
        ratingView.addSubviews([ratingLabel,
                                ratingStackView])
        
        commentView.addSubviews([commentLabel,
                                 commentTextView])
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
        
        [titleLabel,
         authorLabel,
         publisherLabel,
         pagesLabel,
         descriptionLabel,
         startDateLabel,
         endDateLabel,
         ratingLabel,
         commentLabel].forEach { label in
            label.snp.makeConstraints { make in
                make.top.leading.equalToSuperview()
                make.height.equalTo(heightTextField)
            }
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(heightTextField)
        }
        
        authorTextField.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(heightTextField)
        }
        
        
        publisherTextField.snp.makeConstraints { make in
            make.top.equalTo(publisherLabel.snp.bottom).offset(0)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(heightTextField)
        }
        
        pagesTextField.snp.makeConstraints { make in
            make.top.equalTo(pagesLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(heightTextField)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        wishListButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        libraryButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        startDateTextField.snp.makeConstraints { make in
            make.top.equalTo(startDateLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(heightTextField)
        }
        
        endDateTextField.snp.makeConstraints { make in
            make.top.equalTo(endDateLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(heightTextField)
        }
        
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
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
    
    private func setupLabels() {
        [titleLabel,
         authorLabel,
         publisherLabel,
         pagesLabel,
         descriptionLabel,
         startDateLabel,
         endDateLabel,
         commentLabel,
         ratingLabel].forEach { label in
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.textColor = .textColor
        }
    }
    //MARK: Date Picker
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
    
    //MARK: Buttons
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
    
    
    //MARK: Stars
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
    
    
    
    //MARK: Selector
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
                            publisher: publisherTextField.text ?? "",
                            description: descriptionTextView.text ?? "",
                            pages: Int(pagesTextField.text ?? "") ?? 0,
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
    
    //MARK: Image
    private func setupEditCoverButton() {
        editCoverButton.addTarget(self, action: #selector(editCoverTapped), for: .touchUpInside)
    }
    
    @objc
    private func editCoverTapped() {
        let alert = UIAlertController(title: "Обложка", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Загрузить из галереи", style: .default, handler: { _ in
            self.openImagePicker()
        }))
        
        //delete if image not mock
        if let currentImage = viewModel?.getCoverImage(),
           currentImage != UIImage(named: "mock") {
            alert.addAction(UIAlertAction(title: "Удалить обложку", style: .destructive, handler: { _ in
                self.viewModel?.markImageForDeletion()
                self.coverImageView.image = self.viewModel?.getCoverImage()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    private func openImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
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
