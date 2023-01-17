//
//  APIManager.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/03.
//

import Foundation

enum APIError {
    case inValidResponse
    case noData
    case failedRequest
    case invalidData
}

class APIManager {
    static var startCount = 1
    static var displayCount = 15
    
    static func requestBookInformation(query: String, completion: @escaping (BookInfo?, APIError?) -> Void) {
        //페이지네이션 적용예정
        var urlComponents = URLComponents(string: EndPoint.naverBookResultsURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: "\(displayCount)"),
            URLQueryItem(name: "start", value: "\(startCount)")
        ]
 
        var urlRequest = URLRequest(url: (urlComponents?.url)!)
        urlRequest.setValue("tfYqqDDQUPRUW3CIm5x4", forHTTPHeaderField: "X-Naver-Client-Id")
        urlRequest.setValue("NAoG26YRAW", forHTTPHeaderField: "X-Naver-Client-Secret")

        URLSession.shared.dataTask(with: urlRequest) { data, urlResponse, error in
            guard error == nil else {
                print("Failed Request")
                completion(nil, .failedRequest)
                return
            }
            
            guard let data = data else {
                print("No Data Returned")
                completion(nil, .noData)
                return
            }
            
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                print("Unable Response")
                completion(nil, .inValidResponse)
                return
            }
            
            guard urlResponse.statusCode == 200 else {
                print("Invalid Response")
                print(urlResponse)
                completion(nil, .failedRequest)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(BookInfo.self, from: data)
                completion(result, nil)
            } catch {
                print(error)
                completion(nil, .invalidData)
            }
        }.resume()
    }
}
