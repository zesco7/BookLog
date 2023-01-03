//
//  Codable.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/03.
//

import Foundation

// MARK: - BookInfo
struct BookInfo: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let title: String
    let link: String
    let image: String
    let author, discount, publisher, pubdate: String
    let isbn, itemDescription: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, image, author, discount, publisher, pubdate, isbn
        case itemDescription = "description"
    }
}
