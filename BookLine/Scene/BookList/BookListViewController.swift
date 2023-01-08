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
    
    var bookLocalRealm = try! Realm()
    var bookList : Results<BookData>!
    var categorySortCode : String?
    var navigationTitle : String?
    
    init(categorySortCode: String?, navigationTitle: String?) {
        self.categorySortCode = categorySortCode
        self.navigationTitle = navigationTitle
        //필터링 조건 초기화 boolean
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
    }
    
    @objc func memoContentsReceived(notification: NSNotification) {
        if let isbn = notification.userInfo?["isbn"], let comment = notification.userInfo?["comment"] as? String, let memo = notification.userInfo?["memo"] as? String {
            bookList = bookLocalRealm.objects(BookData.self).filter("ISBN = '\(isbn)'").sorted(byKeyPath: "lastUpdate", ascending: true)
            print(bookList!)
            try! bookLocalRealm.write({
                bookList.first?.review = comment
                bookList.first?.memo = memo
            })
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
        filterBookList()
        mainView.tableView.reloadData()
    }
    
    func dateFormatter() {
        //날짜표시형식 변경필요(한국시간)
    }
    
    func navigationAttribute() {
        self.navigationItem.title = navigationTitle
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        self.navigationItem.rightBarButtonItems = [plusButton, sortButton]
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
        let sortByLastUpdate = UIAlertAction(title: "최종날짜순", style: .default) { _ in
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
        
        let sortByLastUpdate = UIAction(title: "최종날짜순") { _ in
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
            let vc = BookListViewController(categorySortCode: self.categorySortCode, navigationTitle: self.navigationTitle)
            let navi = UINavigationController(rootViewController: vc)
            let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(self.completionButtonClicked))
            let dummyButton = UIBarButtonItem()
            self.navigationItem.rightBarButtonItems = [dummyButton, completionButton]
            self.present(navi, animated: true)
            self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: true)
            self.mainView.tableView.reloadData()
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
        //guard let entireBookList = entireBookList else { return 0 }
        let entireBookList = bookList?.count ?? 0
        //return entireBookList.count
        return entireBookList
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookListViewCell.identifier , for: indexPath) as? BookListViewCell else { return UITableViewCell() }
        let url = URL(string: bookList[indexPath.row].imageURL)
        cell.backgroundColor = .clear
        cell.bookImage.kf.setImage(with: url)
        cell.bookName.text = bookList[indexPath.row].title
        cell.bookAuthor.text = bookList[indexPath.row].author
        cell.bookRating.text = "\(bookList[indexPath.row].rating)"
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
        let vc = BookMemoViewController(isbn: bookList[indexPath.row].ISBN, review: bookList[indexPath.row].review, memo: bookList[indexPath.row].memo)
        vc.bookTitle = bookList[indexPath.row].title
        vc.bookWriter = bookList[indexPath.row].author
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
    }
