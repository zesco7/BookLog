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
    var bookMemo: BookData
    var isbn: String
    var lastUpdate: Date
    var review: String?
    var memo: String?
    var starRating: Float
    var sliderValue: Float
    var linkURL: String
    
    init(isbn: String, lastUpdate: Date, review: String?, memo: String?, bookMemo: BookData, starRating: Float, linkURL: String) {
        self.isbn = isbn
        self.lastUpdate = lastUpdate
        self.review = review
        self.memo = memo
        self.bookMemo = bookMemo
        self.starRating = starRating
        self.linkURL = linkURL
        self.sliderValue = 0.0
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
        mainView.starRatingSlider.value = starRating
        mainView.lastUpdateDate.text = dateFormatter(date: lastUpdate)
        navigationAttribute()
        buttonAttribute()
        mainView.bookInfoUrlButton.addTarget(self, action: #selector(openBookInfoUrl(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showStarRating()
        print("현재 별점: ", mainView.starRatingSlider.value)
    }
    
    func navigationAttribute() {
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonClicked))
        self.navigationItem.rightBarButtonItem = deleteButton
    }
    
    @objc func deleteButtonClicked() {
        alertForDeleteButton()
    }
    
    func alertForDeleteButton() {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .destructive) { _ in
            try! self.bookMemoLocalRealm.write({
                self.bookMemoLocalRealm.delete(self.bookMemo)
            })
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func buttonAttribute() {
        guard let bookInforUrlButton = mainView.bookInfoUrlButton.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: bookInforUrlButton)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: bookInforUrlButton.count))
        mainView.bookInfoUrlButton.setAttributedTitle(attributedString, for: .normal)
    }
    
    @objc func openBookInfoUrl(_ sender: UIButton) {
        //웹킷으로 앱내부에서 처리하는거 추천
        if let url = URL(string: linkURL) {
                UIApplication.shared.open(url)
              } else {
                print("INCORRECT URL")
              }
    }
    
    func showBookInformation() {
        mainView.bookName.text = bookTitle
        mainView.bookAuthor.text = bookWriter
    }
    
    func showStarRating() {
        if mainView.starRatingSlider.value >= 5 {
            mainView.star1.image = UIImage(systemName: "star.fill")
            mainView.star2.image = UIImage(systemName: "star.fill")
            mainView.star3.image = UIImage(systemName: "star.fill")
            mainView.star4.image = UIImage(systemName: "star.fill")
            mainView.star5.image = UIImage(systemName: "star.fill")
        } else if
            mainView.starRatingSlider.value >= 4.5 {
            mainView.star1.image = UIImage(systemName: "star.fill")
            mainView.star2.image = UIImage(systemName: "star.fill")
            mainView.star3.image = UIImage(systemName: "star.fill")
            mainView.star4.image = UIImage(systemName: "star.fill")
            mainView.star5.image = UIImage(systemName: "star.leadinghalf.filled")
        } else if mainView.starRatingSlider.value >= 4 {
            mainView.star1.image = UIImage(systemName: "star.fill")
            mainView.star2.image = UIImage(systemName: "star.fill")
            mainView.star3.image = UIImage(systemName: "star.fill")
            mainView.star4.image = UIImage(systemName: "star.fill")
            mainView.star5.image = UIImage(systemName: "star")
        } else if mainView.starRatingSlider.value >= 3.5 {
            mainView.star1.image = UIImage(systemName: "star.fill")
            mainView.star2.image = UIImage(systemName: "star.fill")
            mainView.star3.image = UIImage(systemName: "star.fill")
            mainView.star4.image = UIImage(systemName: "star.leadinghalf.filled")
            mainView.star5.image = UIImage(systemName: "star")
        } else if mainView.starRatingSlider.value >= 3 {
            mainView.star1.image = UIImage(systemName: "star.fill")
            mainView.star2.image = UIImage(systemName: "star.fill")
            mainView.star3.image = UIImage(systemName: "star.fill")
            mainView.star4.image = UIImage(systemName: "star")
            mainView.star5.image = UIImage(systemName: "star")
        } else if mainView.starRatingSlider.value >= 2.5 {
            mainView.star1.image = UIImage(systemName: "star.fill")
            mainView.star2.image = UIImage(systemName: "star.fill")
            mainView.star3.image = UIImage(systemName: "star.leadinghalf.filled")
            mainView.star4.image = UIImage(systemName: "star")
            mainView.star5.image = UIImage(systemName: "star")
        } else if mainView.starRatingSlider.value >= 2 {
            mainView.star1.image = UIImage(systemName: "star.fill")
            mainView.star2.image = UIImage(systemName: "star.fill")
            mainView.star3.image = UIImage(systemName: "star")
            mainView.star4.image = UIImage(systemName: "star")
            mainView.star5.image = UIImage(systemName: "star")
        } else if mainView.starRatingSlider.value >= 1.5 {
            mainView.star1.image = UIImage(systemName: "star.fill")
            mainView.star2.image = UIImage(systemName: "star.leadinghalf.filled")
            mainView.star3.image = UIImage(systemName: "star")
            mainView.star4.image = UIImage(systemName: "star")
            mainView.star5.image = UIImage(systemName: "star")
        } else if mainView.starRatingSlider.value >= 1 {
            mainView.star1.image = UIImage(systemName: "star.fill")
            mainView.star2.image = UIImage(systemName: "star")
            mainView.star3.image = UIImage(systemName: "star")
            mainView.star4.image = UIImage(systemName: "star")
            mainView.star5.image = UIImage(systemName: "star")
        } else if mainView.starRatingSlider.value >= 0.5 {
            mainView.star1.image = UIImage(systemName: "star.leadinghalf.filled")
            mainView.star2.image = UIImage(systemName: "star")
            mainView.star3.image = UIImage(systemName: "star")
            mainView.star4.image = UIImage(systemName: "star")
            mainView.star5.image = UIImage(systemName: "star")
        } else {
            mainView.star1.image = UIImage(systemName: "star")
            mainView.star2.image = UIImage(systemName: "star")
            mainView.star3.image = UIImage(systemName: "star")
            mainView.star4.image = UIImage(systemName: "star")
            mainView.star5.image = UIImage(systemName: "star")
        }
    }
    
    func starRatingSliderAttribute() {
        sliderValue = {
            if mainView.starRatingSlider.value - Float(Int(mainView.starRatingSlider.value)) >= 0.5 {
                return Float(Int(mainView.starRatingSlider.value)) + 0.5
            } else {
                return Float(Int(mainView.starRatingSlider.value))
            }
        }()
        mainView.starRatingSlider.addTarget(self, action: #selector(onChangeValue), for: .valueChanged)
    }
    
    @objc func onChangeValue(_ sender: UISlider) {
        NotificationCenter.default.post(name: NSNotification.Name("rating"), object: nil, userInfo: ["isbn": isbn, "starRating": mainView.starRatingSlider.value])
        
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
    
    func dateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        let lastUpdate = lastUpdate
        dateFormatter.locale = Locale(identifier: Locale.current.identifier)
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateFormatted = dateFormatter.string(from: lastUpdate)
        
        return dateFormatted
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BookMemoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        NotificationCenter.default.post(name: NSNotification.Name("memoContents"), object: nil, userInfo: ["isbn": isbn, "comment": mainView.commentTextView.text, "memo": mainView.memoTextView.text])
    }
}

