//
//  WishListViewModel.swift
//  ReadBook
//
//  Created by Кристина Олейник on 25.08.2025.
//

import Foundation
import UIKit
import CoreData

protocol WishListViewModelProtocol {
    var books: [Book] { get }
    var reloadTable: (() -> Void)? { get set }
    
    func getBooks()
}

final class WishListViewModel: WishListViewModelProtocol {
    //MARK: - Properties
    var reloadTable: (() -> Void)?
    
    private(set) var books: [Book] = [] {
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
        books = []
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let request: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        
        do {
            let allBooks = try context.fetch(request)

            let wishListBooks = allBooks.filter { $0.type == TypeBook.wishlist.rawValue }
            print(wishListBooks)
            
            wishListBooks.forEach { bookEntity in
                let book = Book(
                    id: bookEntity.objectID,
                    type: TypeBook(rawValue: Int(bookEntity.type)) ?? .wishlist,
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
                books.append(book)
            }
            
        } catch {
            print("Failed to fetch books: \(error)")
        }
        
    }
}

