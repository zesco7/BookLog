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
        case .all:
            return nil
        case .withoutCategory(let categoryCode):
            return categoryCode
        case .category(let categoryCode):
            return categoryCode
        }
    }
}
