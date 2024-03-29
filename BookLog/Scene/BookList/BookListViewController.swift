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
    let categorySortType : BookSortType
    var navigationTitle : String?
    var booksToMove = Set<String>()
    
    init(categorySortType: BookSortType, navigationTitle: String?) {
        self.categorySortType = categorySortType
        switch categorySortType {
        case .all:
            self.bookList = bookLocalRealm.objects(BookData.self)
        case .category(let categoryCode):
            self.bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categoryCode)'")
        case .withoutCategory(let categoryCode):
            self.bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode != '\(categoryCode)'")
        }
        self.navigationTitle = navigationTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(BookListViewCell.self, forCellReuseIdentifier: BookListViewCell.identifier)
        navigationAttribute()
        notificationCenterAddObserverForBookMemo()
        mainView.tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func notificationCenterAddObserverForBookMemo() {
        NotificationCenter.default.addObserver(self, selector: #selector(memoContentsReceived(notification:)), name: NSNotification.Name("memoContents"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ratingReceived(notification:)), name: NSNotification.Name("rating"), object: nil)
    }

    @objc func memoContentsReceived(notification: NSNotification) {
        if let isbn = notification.userInfo?["isbn"], let lastUpdate = notification.userInfo?["lastUpdate"] as? Date, let comment = notification.userInfo?["comment"] as? String, let memo = notification.userInfo?["memo"] as? String{
            bookList = bookLocalRealm.objects(BookData.self).filter("ISBN == '\(isbn)'").sorted(byKeyPath: "lastUpdate", ascending: true)
            try! bookLocalRealm.write({
                bookList.first?.lastUpdate = lastUpdate
                bookList.first?.review = comment
                bookList.first?.memo = memo
            })
        } else{
            print("BookMemo Not Saved")
        }
        switch categorySortType {
        case .all:
            self.bookList = bookLocalRealm.objects(BookData.self)
        case .category(let categoryCode):
            self.bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categoryCode)'")
        case .withoutCategory(let categoryCode):
            self.bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode != '\(categoryCode)'")
        }
    }
    
    @objc func ratingReceived(notification: NSNotification) {
        if let isbn = notification.userInfo?["isbn"] as? String, let lastUpdate = notification.userInfo?["lastUpdate"] as? Date, let starRating = notification.userInfo?["starRating"] as? Float {
            bookList = bookLocalRealm.objects(BookData.self).filter("ISBN == '\(isbn)'").sorted(byKeyPath: "lastUpdate", ascending: true)
            try! bookLocalRealm.write({
                bookList.first?.lastUpdate = lastUpdate
                bookList.first?.rating = starRating
            })
        } else{
            print("BookMemo Not Saved")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let bookSort = UserDefaults.standard.string(forKey: "bookSort")
        switch categorySortType {
        case .all:
            if bookSort == "title" {
                self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "title", ascending: true)
            } else if bookSort == "rating" {
                self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "rating", ascending: false)
            } else if bookSort == "lastUpdate" {
                self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: false)
            } else {
                self.bookList = self.bookLocalRealm.objects(BookData.self)
            }
        case .category(let categoryCode):
            if bookSort == "title" {
                self.bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categoryCode)'").sorted(byKeyPath: "title", ascending: true)
            } else if bookSort == "rating" {
                self.bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categoryCode)'").sorted(byKeyPath: "rating", ascending: false)
            } else if bookSort == "lastUpdate" {
                self.bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categoryCode)'").sorted(byKeyPath: "lastUpdate", ascending: false)
            } else {
                self.bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categoryCode)'")
            }
        case .withoutCategory(let categoryCode):
            mainView.tableView.allowsMultipleSelection = true
            self.bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode != '\(categoryCode)'")
            let closeButton = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(self.closeButtonClicked))
            let moveButton = UIBarButtonItem(title: "이동", style: .plain, target: self, action: #selector(moveButtonClicked))
            self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            self.navigationController?.navigationBar.tintColor = .navigationBar
            self.navigationItem.leftBarButtonItem = closeButton
            self.navigationItem.rightBarButtonItem = moveButton
        default:
            return
        }
        self.mainView.tableView.reloadData()
    }
    
    @objc func closeButtonClicked() {
        switch categorySortType {
        case .withoutCategory(let categoryCode):
            self.dismiss(animated: true)
        default:
            return
        }
    }
    
    func navigationAttribute() {
        switch categorySortType {
        case .all:
            self.navigationItem.title = navigationTitle
            self.navigationController!.navigationBar.tintColor = .navigationBar
            let plusButton = self.navigationItem.makeSFSymbolButton(target: self, action: #selector(plusButtonClicked), symbolName: "plus")
            let sortButton = self.navigationItem.makeSFSymbolButton(target: self, action: #selector(sortButtonClicked), symbolName: "list.bullet")
            let deleteButton = self.navigationItem.makeSFSymbolButton(target: self, action: #selector(deleteButtonClicked), symbolName: "trash")
            let deleteButtonForEditing = self.navigationItem.makeSFSymbolButton(target: self, action: #selector(deleteButtonForEditingClicked), symbolName: "trash.slash")
            if mainView.tableView.isEditing == true {
                self.navigationItem.rightBarButtonItems = [plusButton, sortButton, deleteButtonForEditing]
            } else {
                self.navigationItem.rightBarButtonItems = [plusButton, sortButton, deleteButton]
            }
        case .category(let categoryCode):
            self.navigationItem.title = navigationTitle
            self.navigationController!.navigationBar.tintColor = .navigationBar
            let plusButton = self.navigationItem.makeSFSymbolButton(target: self, action: #selector(plusButtonClicked), symbolName: "plus")
            let sortButton = self.navigationItem.makeSFSymbolButton(target: self, action: #selector(sortButtonClicked), symbolName: "list.bullet")
            let deleteButton = self.navigationItem.makeSFSymbolButton(target: self, action: #selector(deleteButtonClicked), symbolName: "trash")
            let deleteButtonForEditing = self.navigationItem.makeSFSymbolButton(target: self, action: #selector(deleteButtonForEditingClicked), symbolName: "trash.slash")
            if mainView.tableView.isEditing == true {
                self.navigationItem.rightBarButtonItems = [plusButton, sortButton, deleteButtonForEditing]
            } else {
                self.navigationItem.rightBarButtonItems = [plusButton, sortButton, deleteButton]
            }
        case .withoutCategory(let categoryCode):
            self.navigationItem.title = navigationTitle
            self.navigationController!.navigationBar.tintColor = .navigationBar
        }
    }
    
    @objc func plusButtonClicked() {
        switch categorySortType {
        case .all:
            let vc = BookSearchViewController(categorySortCode: categorySortType.categorySortCode)
            self.navigationController?.pushViewController(vc, animated: true)
        case .category:
            actionSheetForBookSearch()
        default:
            return
        }
    }
    
    @objc func sortButtonClicked() {
            sortBookList()
    }
    
    @objc func deleteButtonClicked() {
        mainView.tableView.isEditing = true
        navigationAttribute()
        toolbarAttribute(toolbarHidden: false)
    }
    
    @objc func deleteButtonForEditingClicked() {
        mainView.tableView.isEditing = false
        navigationAttribute()
        toolbarAttribute(toolbarHidden: true)
    }
    
    @objc func moveButtonClicked() {
        switch categorySortType {
        case .withoutCategory(let categoryCode):
            let alert = UIAlertController(title: "선택한 책을 이동하시겠습니까?", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default) { _ in
                try! self.bookLocalRealm.write({
                    self.booksToMove.forEach { isbn in
                        let checkBooks = self.bookLocalRealm.object(ofType: BookData.self, forPrimaryKey: isbn)
                        checkBooks?.categorySortCode = categoryCode
                    }
                })
                self.dismiss(animated: true)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        default:
            return
        }
    }
    
    func toolbarAttribute(toolbarHidden: Bool) {
        self.navigationController?.isToolbarHidden = toolbarHidden
        self.navigationController?.toolbar.tintColor = .navigationBar
        var items = [UIBarButtonItem]()
        items.append(UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(toolbarCancelClicked)))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(toolbarDeleteClicked)))
        toolbarItems = items
    }
    
    @objc func toolbarCancelClicked() {
        mainView.tableView.isEditing = false
        navigationAttribute()
        toolbarAttribute(toolbarHidden: true)
    }
    
    @objc func toolbarDeleteClicked() {
        if let selectedItems = mainView.tableView.indexPathsForSelectedRows, selectedItems.count >= 1 {
            var deleteTarget = Array<String>()
            selectedItems.forEach { indexPath in
                deleteTarget.append(bookList[indexPath.row].ISBN)
            }
            deleteTarget.forEach { isbn in
                try! bookLocalRealm.write({
                    bookLocalRealm.delete(bookLocalRealm.object(ofType: BookData.self, forPrimaryKey: isbn)!)
                })
            }
            mainView.tableView.reloadData()
        } else {
            let alert = UIAlertController(title: "삭제할 책을 선택해주세요.", message: nil, preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
        mainView.tableView.isEditing = false
        navigationAttribute()
        toolbarAttribute(toolbarHidden: true)
    }
    
    func sortBookList() {
        switch categorySortType {
        case .all:
            bookList = bookLocalRealm.objects(BookData.self)
            let actionSheet = UIAlertController(title: "정렬기준을 선택해주세요.", message: nil, preferredStyle: .actionSheet)
            let sortBytitle = UIAlertAction(title: "제목순", style: .default) { _ in
                self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "title", ascending: true)
                UserDefaults.standard.set("title", forKey: "bookSort")
                self.mainView.tableView.reloadData()
            }
            let sortByRating = UIAlertAction(title: "별점 높은순", style: .default) { _ in
                self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "rating", ascending: false)
                UserDefaults.standard.set("rating", forKey: "bookSort")
                self.mainView.tableView.reloadData()
            }
            let sortByLastUpdate = UIAlertAction(title: "최종 수정일순", style: .default) { _ in
                self.bookList = self.bookLocalRealm.objects(BookData.self).sorted(byKeyPath: "lastUpdate", ascending: false)
                UserDefaults.standard.set("lastUpdate", forKey: "bookSort")
                self.mainView.tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            actionSheet.addAction(sortBytitle)
            actionSheet.addAction(sortByRating)
            actionSheet.addAction(sortByLastUpdate)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
        case .category(let categoryCode):
            bookList = bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categoryCode)'")
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let sortBytitle = UIAlertAction(title: "제목순", style: .default) { _ in
                self.bookList = self.bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categoryCode)'").sorted(byKeyPath: "title", ascending: true)
                UserDefaults.standard.set("title", forKey: "bookSort")
                self.mainView.tableView.reloadData()
            }
            let sortByRating = UIAlertAction(title: "별점 높은순", style: .default) { _ in
                self.bookList = self.bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categoryCode)'").sorted(byKeyPath: "rating", ascending: false)
                UserDefaults.standard.set("rating", forKey: "bookSort")
                self.mainView.tableView.reloadData()
            }
            let sortByLastUpdate = UIAlertAction(title: "최종 수정일순", style: .default) { _ in
                self.bookList = self.bookLocalRealm.objects(BookData.self).filter("categorySortCode == '\(categoryCode)'").sorted(byKeyPath: "lastUpdate", ascending: false)
                UserDefaults.standard.set("lastUpdate", forKey: "bookSort")
                self.mainView.tableView.reloadData()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            actionSheet.addAction(sortBytitle)
            actionSheet.addAction(sortByRating)
            actionSheet.addAction(sortByLastUpdate)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
        default:
            return
        }
    }
    
    func actionSheetForBookSearch() {
        let actionSheet = UIAlertController(title: "원하는 책을 찾아보세요", message: nil, preferredStyle: .actionSheet)
        let searchingForNewBook = UIAlertAction(title: "새 책 찾기", style: .default) { _ in
            let vc = BookSearchViewController(categorySortCode: self.categorySortType.categorySortCode)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let searchingForSavedBook = UIAlertAction(title: "저장된 책에서 찾기", style: .default) { _ in
            switch self.categorySortType {
            case .category(let categoryCode):
                let vc = BookListViewController(categorySortType: .withoutCategory(categoryCode: categoryCode), navigationTitle: UserDefaults.standard.string(forKey: "defaultCategoryTitle"))
                let navi = UINavigationController(rootViewController: vc)
                navi.modalPresentationStyle = .fullScreen
                self.present(navi, animated: true)
            default:
                return
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(searchingForNewBook)
        actionSheet.addAction(searchingForSavedBook)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let bookList = bookList else { return 0 }
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookListViewCell.identifier , for: indexPath) as? BookListViewCell else { return UITableViewCell() }
        let url = URL(string: bookList[indexPath.row].imageURL)
        cell.backgroundColor = .tableViewCellColor
        cell.bookImage.kf.setImage(with: url)
        cell.bookName.text = bookList[indexPath.row].title
        cell.bookAuthor.text = bookList[indexPath.row].author
        
        if bookList[indexPath.row].rating >= 5 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.fill")
            cell.star4.image = UIImage(systemName: "star.fill")
            cell.star5.image = UIImage(systemName: "star.fill")
        } else if
            bookList[indexPath.row].rating >= 4.5 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.fill")
            cell.star4.image = UIImage(systemName: "star.fill")
            cell.star5.image = UIImage(systemName: "star.leadinghalf.filled")
        } else if bookList[indexPath.row].rating >= 4 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.fill")
            cell.star4.image = UIImage(systemName: "star.fill")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating >= 3.5 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.fill")
            cell.star4.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating >= 3 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.fill")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating >= 2.5 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating >= 2 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.fill")
            cell.star3.image = UIImage(systemName: "star")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating >= 1.5 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star.leadinghalf.filled")
            cell.star3.image = UIImage(systemName: "star")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating >= 1 {
            cell.star1.image = UIImage(systemName: "star.fill")
            cell.star2.image = UIImage(systemName: "star")
            cell.star3.image = UIImage(systemName: "star")
            cell.star4.image = UIImage(systemName: "star")
            cell.star5.image = UIImage(systemName: "star")
        } else if bookList[indexPath.row].rating >= 0.5 {
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
                    print("Book Deleted")
                }
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
        deleteMemo.image = UIImage(systemName: "trash.fill")
        deleteMemo.backgroundColor = .red
        let config = UISwipeActionsConfiguration(actions: [deleteMemo])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch categorySortType {
        case .all, .category(categoryCode: bookList[indexPath.row].categorySortCode):
            let vc = BookMemoViewController(isbn: bookList[indexPath.row].ISBN, lastUpdate: bookList[indexPath.row].lastUpdate, review: bookList[indexPath.row].review, memo: bookList[indexPath.row].memo, bookMemo: bookList[indexPath.row], starRating: bookList[indexPath.row].rating, linkURL: bookList[indexPath.row].linkURL)
            vc.bookTitle = bookList[indexPath.row].title
            vc.bookWriter = bookList[indexPath.row].author
            if mainView.tableView.isEditing == false {
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                return
            }
        case .withoutCategory(let categoryCode):
            self.booksToMove.insert(self.bookList[indexPath.row].ISBN)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        booksToMove.remove(bookList[indexPath.row].ISBN)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
