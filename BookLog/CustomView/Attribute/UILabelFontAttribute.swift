//
//  UILabelFontAttribute.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/01.
//

import UIKit

class UILabelFontAttribute: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.textColor = .black
        self.font = .systemFont(ofSize: 15)
        self.numberOfLines = 0
    }
}
