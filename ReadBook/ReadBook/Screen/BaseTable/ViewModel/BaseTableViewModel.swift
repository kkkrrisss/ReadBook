//
//  BaseTableViewModel.swift
//  ReadBook
//
//  Created by Кристина Олейник on 28.08.2025.
//

import Foundation
import UIKit
import CoreData

protocol BaseTableViewModelProtocol {
    var section: [TableViewSection] { get set }
    var reloadTable: (() -> Void)? { get set }
    
    func getBooks()
    func deleteBook(at indexPath: IndexPath)
}

class BaseTableViewModel: BaseTableViewModelProtocol {
    
    //MARK: - Properties
    var reloadTable: (() -> Void)?
    
    var section: [TableViewSection] = [] {
        didSet {
            reloadTable?()
        }
    }
    
    //MARK: - Initialization
    init() {
        getBooks()
    }
    
    //MARK: - Methods
    func getBooks() {

    }
    
    func deleteBook(at indexPath: IndexPath) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        guard let book = section[indexPath.section].items[indexPath.row] as? Book,
        let objectID = book.id else { return }
        
        let object = context.object(with: objectID)
        context.delete(object)
        
        do {
            try context.save()
            getBooks()
        } catch {
            print("Error deleting book: \(error)")
        }
    }
    
}
