//
//  ApiManager.swift
//  ReadBook
//
//  Created by Кристина Олейник on 27.08.2025.
//

import Foundation

final class ApiManager {
    private static let baseUrl = "https://www.googleapis.com/books/v1/volumes?"
    
    static func getBooks(searchText: String?,
                         completion: @escaping (Result<[Item], Error>) -> ()) {
        var searchParameter: String = ""
        if let searchText = searchText {
            let text = getText(text: searchText)
            searchParameter = "q=\(text)"
        }
        let stringUrl = baseUrl + searchParameter
        
        guard let url = URL(string: stringUrl) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            handleResponse(data: data, response: response, error: error, completion: completion)
        }
        session.resume()
    }
   
    private static func getText(text: String) -> String {
        let s1 = text.components(separatedBy: " ").filter { !$0.isEmpty }
        let s2 = s1.joined(separator: " ")
        let s3 = s2.replacingOccurrences(of: " ", with: "%")
        
        return s3
    }
    
    private static func handleResponse(data: Data?,
                                       response: URLResponse?,
                                       error: Error?,
                                       completion: @escaping (Result<[Item], Error>) -> ()) {
        if let error = error {
            completion(.failure(NetworkingError.networkingError(error)))
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(NetworkingError.unknown))
            return
        }
        guard httpResponse.statusCode == 200 else {
            completion(.failure(NetworkingError.apiError(statusCode: httpResponse.statusCode)))
            return
        }
        
        guard let data = data else {
            completion(.failure(NetworkingError.unknown))
            return
        }
        
        do {
            //JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
            let model = try JSONDecoder().decode(BookResponseObject.self, from: data)
            completion(.success(model.items))
        }
        catch let decodeError {
            completion(.failure(decodeError))
        }
    }
    
    static func getImageData(url: String,
                             completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared.dataTask(with: url) {
            data, _, error in
            if let data = data {
                completion(.success(data))
            }
            if let error = error {
                completion(.failure(error))
            }
        }
        session.resume()
    }
}
