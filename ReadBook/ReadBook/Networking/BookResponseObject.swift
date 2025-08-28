//
//  BookResponseObject.swift
//  ReadBook
//
//  Created by Кристина Олейник on 27.08.2025.
//

import Foundation

struct BookResponseObject: Codable {
    let totalItems: Int
    let items: [Item]
    
    enum CodingKeys: CodingKey {
        case totalItems
        case items
    }
}

struct Item: Codable {
    let volumeInfo: VolumeInfo
    
    enum CodingKeys: CodingKey {
        case volumeInfo
    }
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let description: String?
    let pageCount: Int?
    let imageLinks: ImageLinks?
    
    enum CodingKeys: CodingKey {
        case title
        case authors
        case publisher
        case description
        case pageCount
        case imageLinks
    }
}

struct ImageLinks: Codable {
    let thumbnail: String?
    
    enum CodingKeys: CodingKey {
        case thumbnail
    }
}
