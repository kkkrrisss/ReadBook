//
//  LibraryListViewModel.swift
//  ReadBook
//
//  Created by Кристина Олейник on 23.08.2025.
//

import Foundation
import UIKit
import CoreData

protocol LibraryListViewModelProtocol {
    var section: [TableViewSection] { get }
    var reloadTable: (() -> Void)? { get set }
    
    func getBooks()
    func deleteBook(at indexPath: IndexPath)
}

final class LibraryListViewModel: LibraryListViewModelProtocol {
    //MARK: - Properties
    var reloadTable: (() -> Void)?
    
    private(set) var section: [TableViewSection] = [] {
        didSet {
            reloadTable?()
        }
    }
    
    //MARK: - Initialization
    init() {
        getBooks()
        print(section)
    }
    
    //MARK: - Methods
    func getBooks() {
        section = []
        
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            let allBooks = try context.fetch(request)
            
            let libraryBooks = allBooks.filter { $0.type == TypeBook.library.rawValue }
            
            let sortedBooks = libraryBooks.sorted {
                guard let date1 = $0.startDate, let date2 = $1.startDate else { return false }
                return date1 > date2
            }
            
            let groupedBooks = sortedBooks.reduce(into: [Date: [Book]]()) { result, bookEntity in
                guard let date = bookEntity.endDate else { return }
                let components = Calendar.current.dateComponents([.year, .month], from: date)
                if let startOfMonth = Calendar.current.date(from: components) {
                    let book = Book(
                        id: bookEntity.objectID,
                        type: TypeBook(rawValue: Int(bookEntity.type)) ?? .library,
                        title: bookEntity.title ?? "",
                        author: bookEntity.author ?? "",
                        publisher: bookEntity.publisher,
                        description: bookEntity.text,
                        pages: Int(bookEntity.pages),
                        imageURL: bookEntity.imageURL,
                        rating: Int(bookEntity.rating),
                        startDate: bookEntity.startDate,
                        endDate: bookEntity.endDate,
                        comment: bookEntity.comment
                    )
                    result[startOfMonth, default: []].append(book)
                }
            }
            
            let keys = groupedBooks.keys.sorted(by: >)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            
            keys.forEach { key in
                let stringDate = dateFormatter.string(from: key)
                section.append(TableViewSection(title: stringDate,
                                                items: groupedBooks[key] ?? []))
            }
            
        } catch {
            print("Failed to fetch books: \(error)")
        }
        
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
