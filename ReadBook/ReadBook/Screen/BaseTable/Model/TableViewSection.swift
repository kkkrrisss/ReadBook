//
//  TableViewSection.swift
//  ReadBook
//
//  Created by Кристина Олейник on 24.08.2025.
//

import Foundation

protocol TableViewItemProtocol { }

struct TableViewSection {
    var title: String?
    var items: [TableViewItemProtocol]
}
