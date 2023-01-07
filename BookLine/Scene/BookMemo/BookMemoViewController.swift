//
//  BookMemoViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/30.
//

import UIKit
import RealmSwift

class BookMemoViewController: BaseViewController {
    var mainView = BookMemoView()
    var bookTitle: String?
    var bookWriter: String?
    var bookMemoLocalRealm = try! Realm()
    var bookMemo: Results<BookData>!
    var isbn: String
    var review: String?
    var memo: String?
    
    init(isbn: String, review: String?, memo: String?) {
        self.isbn = isbn
        self.review = review
        self.memo = memo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        starRatingSliderAttribute()
        showBookInformation()
        hideKeyboard()
        mainView.memoTextView.delegate = self
        mainView.commentTextView.delegate = self
        mainView.commentTextView.text = review
        mainView.memoTextView.text = memo
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

extension BookMemoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        NotificationCenter.default.post(name: NSNotification.Name("memoContents"), object: nil, userInfo: ["isbn": isbn, "comment": mainView.commentTextView.text, "memo": mainView.memoTextView.text])
    }
}

