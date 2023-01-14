//
//  BookSortType.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/13.
//

import Foundation

enum BookSortType {
    case all(categoryCode: String)
    case category(categoryCode: String)
    case withoutCategory(categoryCode: String)
    
    var categorySortCode: String? {
        switch self {
        case .all(let categoryCode):
            return categoryCode
        case .withoutCategory:
            return nil
        case .category(let categoryCode):
            return categoryCode
        }
    }
    
    //    var navigationRightBarItems: [String] {
    //        switch self {
    //        case .all:
    //            return []
    //        case .category(let categoryCode):
    //            return ["정렬", "plus.image"]
    //        case .withoutCategory(let categoryCode):
    //            return []
    //        }
    //    }
}
