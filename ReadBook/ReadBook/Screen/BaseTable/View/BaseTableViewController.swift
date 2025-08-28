//
//  BaseTableViewController.swift
//  ReadBook
//
//  Created by Кристина Олейник on 28.08.2025.
//

import UIKit

class BaseTableViewController: UITableViewController {
    //MARK: - Properties
    var viewModel: BaseTableViewModelProtocol?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
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
    
    //MARK: - Initialization
    
    init (viewModel: BaseTableViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

//MARK: - UITableViewDelegate
extension BaseTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.section.count ?? 0
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
}

