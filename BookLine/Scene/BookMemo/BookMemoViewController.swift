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
    
    init(isbn: String, lastUpdate: Date, review: String?, memo: String?, bookMemo: BookData, starRating: Float) {
        self.isbn = isbn
        self.lastUpdate = lastUpdate
        self.review = review
        self.memo = memo
        self.bookMemo = bookMemo
        self.starRating = starRating
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
        toolBarAttribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    func toolBarAttribute() {
        //네비게이션에 있는 툴바속성을 사용 못하는 이유?
        //툴바기본높이 속성 적용 안되는 이유?
//        self.navigationController?.isToolbarHidden = false
//        self.navigationController?.setToolbarHidden(false, animated: true)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let saveButton = UIBarButtonItem(title: "메모파일 저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        let deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteButtonClicked))
        let barButtonItems = [saveButton, flexSpace, deleteButton]
        self.mainView.toolBar.setItems(barButtonItems, animated: false)
        mainView.toolBar.isHidden = false
        mainView.toolBar.sizeToFit()
        mainView.commentTextView.inputAccessoryView = mainView.toolBar
        mainView.memoTextView.inputAccessoryView = mainView.toolBar
    }
    
    @objc func saveButtonClicked() {
        //@리팩토링: realm데이터파일 생성 추가예정
    }
    
    @objc func deleteButtonClicked() {
        alertForDeleteButton()
    }
    
    func alertForDeleteButton() {
        let alert = UIAlertController(title: "삭제하시겠습니까", message: nil, preferredStyle: .alert)
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
        //let lastUpdate = Date()
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

