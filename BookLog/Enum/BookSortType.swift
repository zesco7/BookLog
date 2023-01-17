//
//  BookSortType.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/13.
//

import Foundation

enum BookSortType {
    case all
    case category(categoryCode: String)
    case withoutCategory(categoryCode: String)
    
    var categorySortCode: String? {
        switch self {
        case .all, .withoutCategory:
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
