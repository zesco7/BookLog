//
//  StarImageAttribute.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/11.
//

import UIKit

class StarImageAttribute: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.image = UIImage(systemName: "star")
        self.tintColor = .black
    }
}
