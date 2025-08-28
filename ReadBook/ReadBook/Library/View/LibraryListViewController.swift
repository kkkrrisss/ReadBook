//
//  LibraryListViewController.swift
//  ReadBook
//
//  Created by Кристина Олейник on 23.08.2025.
//

import UIKit

final class LibraryListViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Library"
    }
    
}


//MARK: - UITableViewDelegate
extension LibraryListViewController {
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        viewModel?.section[section].title
    }
    
    override func tableView(_ tableView: UITableView,
                            willDisplayHeaderView view: UIView,
                            forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.contentView.backgroundColor = .darkBG
            header.textLabel?.textColor = .textColor
            header.textLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }
}

