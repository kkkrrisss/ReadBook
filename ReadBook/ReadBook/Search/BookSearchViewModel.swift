//
//  BookSearchViewModel.swift
//  ReadBook
//
//  Created by Кристина Олейник on 27.08.2025.
//

import Foundation
import UIKit
import CoreData

protocol BookSearchViewModelProtocol {
    var books: [Book] { get }
    var reloadData: (() -> Void)? { get set }
    var reloadCell: ((IndexPath) -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
    
    func searchBooks(text: String?)
}

final class BookSearchViewModel: BookSearchViewModelProtocol {
    
    var searchText: String? = nil
    private(set) var books: [Book] = []
    
    var reloadData: (() -> Void)?
    var showError: ((String) -> Void)?
    var reloadCell: ((IndexPath) -> Void)?
    
    //MARK: - Methods
    func searchBooks(text: String?) {
        ApiManager.getBooks(searchText: text) { [weak self] result in
            self?.handleResult(result)
        }
    }
    
    func handleResult(_ result: Result<[Item], Error>) {
        switch result {
        case .success(let articles):
            self.convertCellViewModel(articles)
            self.loadImage()
        case .failure(let error):
            DispatchQueue.main.async {
                let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                self.showError?(message)
                print(error)
            }
        }
    }
    
    func convertCellViewModel(_ books: [Item]) {
        let viewModels = books.map { Book(book: $0) }
        
        self.books = viewModels
            DispatchQueue.main.async { [weak self] in
                self?.reloadData?()
            }
    }
    
    
    private func loadImage() {
        for (index, item) in books.enumerated() {
              if  let url = item.imageString {
                ApiManager.getImageData(url: url) { [weak self] result in
                    
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            self?.books[index].imageData = data
                            self?.reloadCell?(IndexPath(row: index, section: 0))
                        case .failure(let error):
                            self?.showError?(error.localizedDescription)
                        }
                    }
                }
            }
        }
        
    }
}

