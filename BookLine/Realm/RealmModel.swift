//
//  RealmModel.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/28.
//

import UIKit
import RealmSwift

class BookData: Object { //테이블이름: BookData, 컬럼이름: ~~(@persisted var ~~)
    @Persisted var categorySortCode: Int
    @Persisted var ISBN: String
    @Persisted var rating: Double?
    @Persisted var review: String?
    @Persisted var memo: String?
    @Persisted var title: String
    @Persisted var author: String
    @Persisted var publisher: String
    @Persisted var pubdate = Date()
    @Persisted var linkURL: String
    @Persisted var imageURL: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId //PK선언(realm에서 제공하는 objectId가 기본값으로 사용됨)
    
    //초기화: objectId는 realm에서 자동설정되기 때문에 objectId를 제외한 나머지를 초기화
    convenience init(categorySortCode: Int, ISBN: String, rating: Double?, review: String?, memo: String?, title: String, author: String, publisher: String, pubdate: Date, linkURL: String, imageURL: String) {
        self.init()
        self.categorySortCode = categorySortCode
        self.ISBN = ISBN
        self.rating = rating
        self.review = review
        self.memo = memo
        self.title = title
        self.author = author
        self.publisher = publisher
        self.pubdate = pubdate
        self.linkURL = linkURL
        self.imageURL = imageURL
    }
}

class CategoryData: Object {
    @Persisted(primaryKey: true) var categorySortCode: ObjectId
    @Persisted var order: Int
    @Persisted var category: String
    @Persisted var savedBook: Int
    
    convenience init(order: Int, category: String, savedBook: Int) {
        self.init()
        self.order = order
        self.category = category
        self.savedBook = savedBook
    }
}

