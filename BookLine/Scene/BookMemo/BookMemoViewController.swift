//
//  BookMemoViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/30.
//

import UIKit

class BookMemoViewController: BaseViewController {
    var mainView = BookMemoView()
    var bookTitle: String?
    var bookWriter: String?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starRatingSliderAttribute()
        showBookInformation()
        hideKeyboard()
        
        //별점, 한줄평, 메모내용 작성하고 pop하면 notificationCenter로 데이터 넘겨서 realm에 저장되도록 처리
        
    }
    
    func showBookInformation() {
        mainView.bookName.text = bookTitle
        mainView.bookAuthor.text = bookWriter
    }
    
    func starRatingSliderAttribute() {
        var sliderValue: Float {
            if mainView.starRatingSlider.value - Float(Int(mainView.starRatingSlider.value)) >= 0.5 {
                return Float(Int(mainView.starRatingSlider.value)) + 0.5
            } else {
                return Float(Int(mainView.starRatingSlider.value))
            }
        }
        mainView.starRatingSlider.addTarget(self, action: #selector(onChangeValue), for: .valueChanged)
    }
    
    @objc func onChangeValue(_ sender: UISlider) {
        let floatValue = floor(sender.value * 10) / 10
        
        for i in 1...5 {
            if let starImage = view.viewWithTag(i) as? UIImageView {
                if Float(i) <= floatValue {
                    starImage.image = UIImage(systemName: "star.fill")
                } else if (Float(i)-floatValue) <= 0.5 {
                    starImage.image = UIImage(systemName: "star.leadinghalf.filled")
                } else {
                    starImage.image = UIImage(systemName: "star")
                }
            }
        }
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BookMemoViewController: UIToolbarDelegate {
    
}

