//
//  HomeScreenViewController.swift
//  ReadBook
//
//  Created by Кристина Олейник on 20.08.2025.
//

import UIKit
import SnapKit

class HomeScreenViewController: UIViewController {

    //MARK: - GUI Properties
    private let titleLabel1: UILabel = {
        let label = UILabel()
        
        label.text = "Read"
        label.font = UIFont.systemFont(ofSize: 80, weight: .black)
        label.textAlignment = .center
        label.textColor = .darkBord
        
        return label
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        
        label.text = "Book"
        label.font = UIFont.systemFont(ofSize: 80, weight: .black)
        label.textColor = .darkBord
        label.textAlignment = .center
        
        return label
    }()
    
    private let addBookButton: UIButton = {
        let button = UIButton()

        return button
    }()
    
    private let libraryButton: UIButton = {
        let button = UIButton()

        return button
    }()
    
    private let wishListButton: UIButton = {
        let button = UIButton()

        return button
    }()
    
    //MARK: - Properties
    
    private let cornerRadius: CGFloat = 30
    private let buttonHeight: CGFloat = 80
    private let buttonDist: CGFloat = 25
    
    private var titleTopHeight: CGFloat {
        return (view.frame.height / 2) - 150
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    //MARK: - Private Methods
    private func setupUI() {
        view.addSubview(titleLabel1)
        view.addSubview(titleLabel2)
        view.addSubview(addBookButton)
        view.addSubview(libraryButton)
        view.addSubview(wishListButton)
        
        view.backgroundColor = .background
        
        setupButtons()
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-titleTopHeight)
        }
        
        titleLabel2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel1.snp.bottom).offset(0)
        }
        
        addBookButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel2.snp.bottom).offset(100)
            make.trailing.leading.equalToSuperview().inset(40)
            make.height.equalTo(buttonHeight)
        }
        
        libraryButton.snp.makeConstraints { make in
            make.top.equalTo(addBookButton.snp.bottom).offset(buttonDist)
            make.trailing.leading.equalToSuperview().inset(40)
            make.height.equalTo(buttonHeight)
        }
        
        wishListButton.snp.makeConstraints { make in
            make.top.equalTo(libraryButton.snp.bottom).offset(buttonDist)
            make.trailing.leading.equalToSuperview().inset(40)
            make.height.equalTo(buttonHeight)
        }
    }
    
    private func setupButtons() {
        //AddBookButton
        addBookButton.setTitle("Add Book", for: .normal)
        setupButton(addBookButton)
        addBookButton.addTarget(self, action: #selector(goToBook), for: .touchUpInside)
        
        // libraryButton
        libraryButton.setTitle("My Library", for: .normal)
        setupButton(libraryButton)
        libraryButton.translatesAutoresizingMaskIntoConstraints = false
        libraryButton.addTarget(self, action: #selector(goToLibrary), for: .touchUpInside)
        
        //wishListButton
        wishListButton.setTitle("Wish List", for: .normal)
        setupButton(wishListButton)
        wishListButton.translatesAutoresizingMaskIntoConstraints = false
        wishListButton.addTarget(self, action: #selector(goToWishList), for: .touchUpInside)
    }
    
    private func setupButton(_ button: UIButton) {
        button.setTitleColor(.background, for: .normal)
        button.backgroundColor = .darkBord
        button.layer.cornerRadius = cornerRadius
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    @objc
    private func goToBook() {
        
        let actions = [
               UIAlertAction(title: "Ввести вручную",
                             style: .default) { _ in
                   let bookVC = BookViewController()
                   let viewModel = BookViewModel(book: nil)
                   bookVC.viewModel = viewModel
                   self.navigationController?.pushViewController(bookVC, animated: true)
               },
               UIAlertAction(title: "Поиск",
                             style: .default) { _ in
                   let viewModel = BookSearchViewModel()
                   let searchVC = BookSearchViewController(viewModel: viewModel)
                   self.navigationController?.pushViewController(searchVC, animated: true)
               }
           ]
           
        AlertManager.showActionShit(on: self,
                                    title: "Добавить книгу",
                                    message: "Выберите способ добавления",
                                    actions: actions)
    }
    
    @objc
    private func goToLibrary() {
        let libraryVC = LibraryListViewController(viewModel:  LibraryListViewModel())
        navigationController?.pushViewController(libraryVC, animated: true)
    }
    
    @objc
    private func goToWishList() {
        let wishlistVC = WishListViewController(viewModel:  WishListViewModel())
        navigationController?.pushViewController(wishlistVC, animated: true)
    }
}

