//
//  BookSearchViewController.swift
//  ReadBook
//
//  Created by Кристина Олейник on 27.08.2025.
//

import UIKit
import SnapKit


final class BookSearchViewController: UIViewController {

    // MARK: - GUI Variables
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        
        search.placeholder = "Введите название книги или автора"
        search.searchBarStyle = .minimal
        
        return search
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    // MARK: - Properties
    private var viewModel: BookSearchViewModelProtocol
    
    // MARK: - Init
    init(viewModel: BookSearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        navigationItem.largeTitleDisplayMode = .never
        
        setupUI()
        setupDelegates()
        setupGesture()
        setupViewModel()
    }
    
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .background
        tableView.backgroundColor = .background 
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        tableView.register(BookTableViewCell.self,
                           forCellReuseIdentifier: "BookTableViewCell")
        setupConstraints()
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupViewModel() {
        viewModel.reloadData = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.reloadCell = { [weak self] indexPath in
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private func setupGesture() {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        recognizer.cancelsTouchesInView = false //не блокирует другие события
        view.addGestureRecognizer(recognizer)
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDataSource
extension BookSearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.books.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }

        let book = viewModel.books[indexPath.row]
        cell.set(book: book)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BookSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let book = viewModel.books[indexPath.row]
        //tableView.deselectRow(at: indexPath, animated: true)
        
        let bookVC = BookViewController()
        bookVC.viewModel = BookViewModel(book: book)
        navigationController?.pushViewController(bookVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension BookSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        viewModel.searchBooks(text: text)
        searchBar.resignFirstResponder()
    }
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.searchBooks(text: nil)
        }
    }
}

