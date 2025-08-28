//
//  BookViewModel.swift
//  ReadBook
//
//  Created by Кристина Олейник on 21.08.2025.
//

import Foundation
import UIKit
import CoreData

protocol BookViewModelProtocol {
    var currentRating: Int { get set }
    var typeBook: TypeBook { get set }
    var book: Book? { get }
    
    func save(title: String,
              author: String,
              publisher: String?,
              description: String?,
              pages: Int?,
              startDate: Date?,
              endDate: Date?,
              comment: String?)
    
    func getCoverImage() -> UIImage?
    func setTempImage(_ image: UIImage?)
    func markImageForDeletion()
}

final class BookViewModel: BookViewModelProtocol {
    var book: Book?
    var currentRating: Int
    var typeBook: TypeBook
    
    private var tempImage: UIImage?
    private var shouldDeleteImage = false
    
    
    //MARK: - Initialization
    init(book: Book?) {
        self.book = book
        self.currentRating = book?.rating ?? 0
        self.typeBook = book?.type ?? .wishlist
    }
    
    //MARK: Methods
    
    func save(title: String,
              author: String,
              publisher: String?,
              description: String?,
              pages: Int?,
              startDate: Date?,
              endDate: Date?,
              comment: String?) {
        
        let context = CoreDataStack.shared.context
        let bookEntity: BookEntity
        
        if let book = book,
           let id = book.id{
            bookEntity = context.object(with: id) as! BookEntity
        } else {
            bookEntity = BookEntity(context: context)
        }
        
        bookEntity.title = title
        bookEntity.author = author
        bookEntity.publisher = publisher
        bookEntity.text = description
        bookEntity.pages = Int16(pages ?? 0)
        bookEntity.startDate = startDate
        bookEntity.endDate = endDate
        bookEntity.comment = comment
        bookEntity.rating = Int16(currentRating)
        bookEntity.type = Int16(typeBook.rawValue)
        
        var url = book?.imageURL
        if shouldDeleteImage, let oldURL = url {
            FileManagerPersistent.delete(from: oldURL)
            url = nil
        } else if let image = tempImage {
            let fileName = UUID().uuidString + ".jpg"
            url = FileManagerPersistent.save(image, with: fileName)
        } else if let data = book?.imageData,
                  let image = UIImage(data: data){
            let fileName = UUID().uuidString + ".jpg"
            url = FileManagerPersistent.save(image, with: fileName)
        }
        bookEntity.imageURL = url
        
        CoreDataStack.shared.saveContext()
    }
    
    
    // MARK: - Cover methods
    func getCoverImage() -> UIImage? {
        if let image = tempImage {
            return image
        } else if shouldDeleteImage {
            return UIImage(named: "mock")
        } else if let image = book?.image {
            return image
        } else {
            return UIImage(named: "mock")
        }
    }
    
    func setTempImage(_ image: UIImage?) {
        tempImage = image
        shouldDeleteImage = false
    }
    
    func markImageForDeletion() {
        tempImage = nil
        shouldDeleteImage = true
    }
}
