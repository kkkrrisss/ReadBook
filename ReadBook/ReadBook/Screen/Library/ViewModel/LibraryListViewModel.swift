//
//  LibraryListViewModel.swift
//  ReadBook
//
//  Created by Кристина Олейник on 23.08.2025.
//

import Foundation
import UIKit
import CoreData

final class LibraryListViewModel: BaseTableViewModel {
    
    override func getBooks() {
        super.getBooks()
        
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
}
