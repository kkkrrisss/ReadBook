//
//  Book.swift
//  ReadBook
//
//  Created by Кристина Олейник on 20.08.2025.
//

import Foundation
import CoreData

enum TypeBook: Int {
    case wishlist = 0
    case library = 1
}

struct Book: TableViewItemProtocol {
    let id: NSManagedObjectID
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
}

