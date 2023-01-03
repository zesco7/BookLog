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
    static func requestBookInformation(query: String, display: Int, completion: @escaping (BookInfo?, APIError?) -> Void) {
        let url = URL(string: "\(EndPoint.naverBookResultsURL)query=\(query)&display=\(display)&start=1)")!
        let urlRequest = URLRequest(url: url)
        //urlRequest.setValue(<#T##value: String?##String?#>, forHTTPHeaderField: <#T##String#>)
        
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
                completion(nil, .failedRequest)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(BookInfo.self, from: data)
                completion(result, nil )
            } catch {
                print(error)
                completion(nil, .invalidData)
            }
        }.resume()
    }
}
