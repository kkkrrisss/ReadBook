//
//  LibraryListViewController.swift
//  ReadBook
//
//  Created by Кристина Олейник on 23.08.2025.
//

import UIKit

final class LibraryListViewController: UITableViewController {
    
    //MARK: - Properties
    var viewModel: LibraryListViewModelProtocol?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Library"
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
        
        navigationController?.navigationBar.barTintColor = .background
        
        navigationController?.navigationBar.tintColor = .textColor
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.textColor,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
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

extension LibraryListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.section.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel?.section[section].title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.section[section].items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let book = viewModel?.section[indexPath.section].items[indexPath.row] as? Book else { return UITableViewCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell",
                                                    for: indexPath) as? BookTableViewCell {
            
            cell.set(book: book)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate
extension LibraryListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let book = viewModel?.section[indexPath.section].items[indexPath.row] as? Book else { return }
        let bookVC = BookViewController()
        let viewModel = BookViewModel(book: book)
        bookVC.viewModel = viewModel
        navigationController?.pushViewController(bookVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.viewModel?.deleteBook(at: indexPath)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = .darkBG
            header.textLabel?.textColor = .textColor
            header.textLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }
    
}
