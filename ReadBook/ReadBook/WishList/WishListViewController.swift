//
//  WishListViewController.swift
//  ReadBook
//
//  Created by Кристина Олейник on 25.08.2025.
//

import UIKit

final class WishListViewController: UITableViewController {
    
    //MARK: - Properties
    var viewModel: WishListViewModelProtocol?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Wish List"
        setupTableView()
        registerObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        viewModel?.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Private Methods
    private func setupTableView() {
        tableView.register(BookTableViewCell.self,
                           forCellReuseIdentifier: "BookTableViewCell")
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background

    }
    private func registerObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: NSNotification.Name("Update"),
                                               object: nil)
    }
    @objc
    private func updateData() {
        viewModel?.getBooks()
    }
}

extension WishListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.books.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let book = viewModel?.books[indexPath.row] as? Book else { return UITableViewCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell",
                                                           for: indexPath) as? BookTableViewCell {
            
            cell.set(book: book)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension WishListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let book = viewModel?.books[indexPath.row] as? Book else { return }
        let bookVC = BookViewController()
        let viewModel = BookViewModel(book: book)
        bookVC.viewModel = viewModel
        navigationController?.pushViewController(bookVC, animated: true)
    }
}
