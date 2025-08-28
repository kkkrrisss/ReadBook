//
//  Book.swift
//  ReadBook
//
//  Created by Кристина Олейник on 20.08.2025.
//

import Foundation
import CoreData
import UIKit

enum TypeBook: Int {
    case wishlist = 0
    case library = 1
}

struct Book: TableViewItemProtocol {
    let id: NSManagedObjectID?
    let type: TypeBook
    let title: String
    let author: String
    let publisher: String?
    let description: String?
    let pages: Int?
    let imageURL: URL?
    let rating: Int?
    let startDate: Date?
    let endDate: Date?
    let comment: String?
    
    let imageString: String?
    var imageData: Data?
    
    var image: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        } else if let url = imageURL,
                  let image =  FileManagerPersistent.read(from: url){
            return image
        } else {
            return UIImage(named: "mock")
        }
    }
    
    init(id: NSManagedObjectID?,
         type: TypeBook,
         title: String,
         author: String,
         publisher: String?,
         description: String?,
         pages: Int?,
         imageURL: URL?,
         rating: Int?,
         startDate: Date?,
         endDate: Date?,
         comment: String?,
         imageString: String? = nil,
         imageData: Data? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.author = author
        self.publisher = publisher
        self.description = description
        self.pages = pages
        self.imageURL = imageURL
        self.rating = rating
        self.startDate = startDate
        self.endDate = endDate
        self.comment = comment
        
        self.imageString = imageString
        self.imageData = imageData
        
    }
    
    init(book: Item) {
        title = book.volumeInfo.title
        type = .wishlist
        author = book.volumeInfo.authors?.joined(separator: ", ") ?? ""
        publisher = book.volumeInfo.publisher
        description = book.volumeInfo.description
        pages = book.volumeInfo.pageCount
        imageString = book.volumeInfo.imageLinks?.thumbnail
        rating = nil
        startDate = nil
        endDate = nil
        imageURL = nil
        comment = nil
        id = nil
    }
    
}

