//
//  EntireBookListViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/28.
//

import UIKit
import RealmSwift

class BookListViewController: BaseViewController {
    var mainView = BookListView()
    var mainViewCell = BookListViewCell()
    
    var bookLocalRealm = try! Realm()
    var bookList : Results<BookData>!
    var categorySortCode : String?
    var navigationTitle : String?
    
    init(categorySortCode: String?, navigationTitle: String?) {
        self.categorySortCode = categorySortCode
        self.navigationTitle = navigationTitle
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
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(BookListViewCell.self, forCellReuseIdentifier: BookListViewCell.identifier)
        print(categorySortCode)
        navigationAttribute()
        NotificationCenter.default.addObserver(self, selector: #selector(memoContentsReceived(notification:)), name: NSNotification.Name("memoContents"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ratingReceived(notification:)), name: NSNotification.Name("rating"), object: nil)
    }
    
    @objc func memoContentsReceived(notification: NSNotification) {
        if let isbn = notification.userInfo?["isbn"], let comment = notification.userInfo?["comment"] as? String, let memo = notification.userInfo?["memo"] as? String{
            bookList = bookLocalRealm.objects(BookData.self).filter("ISBN == '\(isbn)'").sorted(byKeyPath: "lastUpdate", ascending: true)
            print(bookList!)
            try! bookLocalRealm.write({
                bookList.first?.review = comment
                bookList.first?.memo = memo
            })
        } else{
            print("BookMemo Not Saved")
        }
    }
    
    @objc func ratingReceived(notification: NSNotification) {
        if let isbn = notification.userInfo?["isbn"] as? String, let starRating = notification.userInfo?["starRating"] as? Float {
            bookList = bookLocalRealm.objects(BookData.self).filter("ISBN == '\(isbn)'").sorted(byKeyPath: "lastUpdate", ascending: true)
            try! bookLocalRealm.write({
                bookList.first?.rating = starRating
            })
            print(starRating)
        } else{
            print("BookMemo Not Saved")
        }
    }
    
    func filterBookList(){
        if let categorySortCode = categorySortCode {
            //카테고라이징
            bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categorySortCode)'")
            print("BookList Filtered")
        } else {
            //전체
            bookList = bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
            print("BookList Unfiltered")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        filterBookList()
        mainView.tableView.reloadData()
    }

    func navigationAttribute() {
        self.navigationItem.title = navigationTitle
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        self.navigationItem.rightBarButtonItems = [plusButton, sortButton]
    }
    
    func modalNavigationAttribute() {

    }
   
    @objc func sortButtonClicked() {
        //iOS14미만: actionSheet
        sortBookList()

        //iOS14+: UImenu
        uiMenuForSort()
    }
    
    @objc func plusButtonClicked() {
        if let categorySortCode = categorySortCode {
            actionSheetForBookSearch()
        } else {
            let vc = BookSearchViewController(categorySortCode: categorySortCode)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func sortBookList() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let sortBytitle = UIAlertAction(title: "제목순", style: .default) { _ in
            self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "title", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let sortByRating = UIAlertAction(title: "별점순", style: .default) { _ in
            self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "rating", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let sortByLastUpdate = UIAlertAction(title: "최종 수정일순", style: .default) { _ in
            self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(sortBytitle)
        actionSheet.addAction(sortByRating)
        actionSheet.addAction(sortByLastUpdate)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    func uiMenuForSort() {
        let sortBytitle = UIAction(title: "제목순") { _ in
            self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "title", ascending: true)
            self.mainView.tableView.reloadData()
        }
        
        let sortByRating = UIAction(title: "별점순") { _ in
            self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "rating", ascending: true)
            self.mainView.tableView.reloadData()
        }
        
        let sortByLastUpdate = UIAction(title: "최종 수정일순") { _ in
            self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
            self.mainView.tableView.reloadData()
        }
        let menu = UIMenu(title: "정렬기준 선택", children: [sortBytitle, sortByRating, sortByLastUpdate])
    }
    
    func actionSheetForBookSearch() {
        let actionSheet = UIAlertController(title: "원하는 책을 찾아보세요", message: nil, preferredStyle: .actionSheet)
        let searchingForNewBook = UIAlertAction(title: "새 책 찾기", style: .default) { _ in
            let vc = BookSearchViewController(categorySortCode: self.categorySortCode)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let searchingForSavedBook = UIAlertAction(title: "저장된 책에서 찾기", style: .default) { _ in
            //vc.bookList로 테이블 갱신 어떻게?
            //네비게이션바버튼 적용 어떻게?
            let vc = BookListViewController(categorySortCode: nil, navigationTitle: UserDefaults.standard.string(forKey: "defaultCategoryTitle"))
            guard let categoryCode = self.categorySortCode else { return }
            vc.bookList = vc.bookLocalRealm.objects(BookData.self).filter("categorySortCode != '\(categoryCode)'")
            vc.mainView.tableView.reloadData()
            print("self: ", self.bookList.count)
            print("Vc: ", vc.bookList.count)
            
            let navi = UINavigationController(rootViewController: vc)
            let dummyButton = UIBarButtonItem()
            let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: vc, action: nil)
            vc.navigationItem.rightBarButtonItem = completionButton
            navi.navigationItem.rightBarButtonItems = [dummyButton, completionButton]
            self.present(navi, animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(searchingForNewBook)
        actionSheet.addAction(searchingForSavedBook)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    @objc func completionButtonClicked() {
        self.dismiss(animated: true)
    }
}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let bookList = bookList else { return 0 }
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookListViewCell.identifier , for: indexPath) as? BookListViewCell else { return UITableViewCell() }
        //셀재사용될 때 공백처리하는게 맞는건지 뷰를 교체?하는게 맞는건지
        mainView.userGuide.text = ""
        let url = URL(string: bookList[indexPath.row].imageURL)
        cell.backgroundColor = .clear
        cell.bookImage.kf.setImage(with: url)
        cell.bookName.text = bookList[indexPath.row].title
        cell.bookAuthor.text = bookList[indexPath.row].author
        
        if bookList[indexPath.row].rating! >= 5 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.fill")
            cell.star4.image = UIImage(systemName: "star.fill")
            cell.star5.image = UIImage(systemName: "star.fill")
        } else if
            bookList[indexPath.row].rating! >= 4.5 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.fill")
            cell.star4.image = UIImage(systemName: "star.fill")
            cell.star5.image = UIImage(systemName: "star.leadinghalf.filled")
        } else if bookList[indexPath.row].rating! >= 4 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.fill")
            cell.star4.image = UIImage(systemName: "star.fill")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating! >= 3.5 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.fill")
            cell.star4.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating! >= 3 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.fill")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating! >= 2.5 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating! >= 2 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating! >= 1.5 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.star3.image = UIImage(systemName: "star")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating! >= 1 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star")
            cell.star3.image = UIImage(systemName: "star")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating! >= 0.5 {
            cell.star1.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.star2.image = UIImage(systemName: "star")
            cell.star3.image = UIImage(systemName: "star")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else {
            cell.star1.image = UIImage(systemName: "star")
            cell.star2.image = UIImage(systemName: "star")
            cell.star3.image = UIImage(systemName: "star")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        }
        
//        cell.bookRating.text = "\(bookList[indexPath.row].rating!)"
        cell.bookReview.text = bookList[indexPath.row].review
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteMemo = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            let alert = UIAlertController(title: "삭제하시겠습니까?", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "삭제", style: .destructive) { _ in
                try! self.bookLocalRealm.write {
                    self.bookLocalRealm.delete(self.bookList[indexPath.row])
                    self.mainView.tableView.reloadData()
                    print("Realm Deleted")
                }
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
        deleteMemo.image = UIImage(systemName: "trash.fill")
        deleteMemo.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteMemo])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = BookMemoViewController(isbn: bookList[indexPath.row].ISBN, lastUpdate: bookList[indexPath.row].lastUpdate, review: bookList[indexPath.row].review, memo: bookList[indexPath.row].memo, bookMemo: bookList[indexPath.row], starRating: bookList[indexPath.row].rating!, linkURL: bookList[indexPath.row].linkURL)
        vc.bookTitle = bookList[indexPath.row].title
        vc.bookWriter = bookList[indexPath.row].author
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
    }
