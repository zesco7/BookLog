//
//  Codable.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/03.
//

import UIKit

// MARK: - BookInfo
struct BookInfo: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let isbn: String
    let title: String
    let author: String
    let publisher : String
    let pubdate: String
    let link: String
    let image: String
    
    func toBookData(lastUpate: Date, categorySortCode: String, review: String?, memo: String?) -> BookData {
        return BookData(lastUpdate: lastUpate, categorySortCode: categorySortCode, ISBN: self.isbn, rating: 0, review: review, memo: memo, title: self.title, author: self.author, publisher: self.publisher, pubdate: self.pubdate, linkURL: self.link, imageURL: self.image)
    }
}
