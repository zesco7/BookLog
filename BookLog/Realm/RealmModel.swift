//
//  RealmModel.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/28.
//

import UIKit
import RealmSwift

class BookData: Object { //테이블이름: BookData, 컬럼이름: ~~(@persisted var ~~)    
    @Persisted var lastUpdate = Date()
    @Persisted var categorySortCode: String
    @Persisted(primaryKey: true) var ISBN: String
    @Persisted var rating: Float
    @Persisted var review: String?
    @Persisted var memo: String?
    @Persisted var title: String
    @Persisted var author: String
    @Persisted var publisher: String
    @Persisted var pubdate: String
    @Persisted var linkURL: String
    @Persisted var imageURL: String
    
    //초기화: objectId는 realm에서 자동설정되기 때문에 objectId를 제외한 나머지를 초기화
    convenience init(lastUpdate: Date, categorySortCode: String, ISBN: String, rating: Float, review: String?, memo: String?, title: String, author: String, publisher: String, pubdate: String, linkURL: String, imageURL: String) {
        self.init()
        self.lastUpdate = lastUpdate
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
    @Persisted var regDate = Date()
    @Persisted var category: String
    
    convenience init(regDate: Date, category: String) {
        self.init()
        self.regDate = regDate
        self.category = category
    }
}

