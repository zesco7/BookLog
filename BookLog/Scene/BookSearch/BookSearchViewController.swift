//
//  BookSearchViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/01.
//

import UIKit
import Kingfisher
import RealmSwift

class BookSearchViewController: BaseViewController {
    var mainView = BookSearchView()
    var bookSearchLocalRealm = try! Realm()
    var bookSearchResults : Results<BookData>!
    var categorySortCode : String?
    var bookInfoArray : [Item]?
    var multiselectionArray = Array<BookData>()
    var searchbarText : String?
    var totalCount = 0
    let searchController = UISearchController(searchResultsController: nil)
    var targetToAdd = Array<String>()
    var duplicationCheckArray = Array<String>()
    
    init(categorySortCode: String?) {
        self.categorySortCode = categorySortCode
        self.multiselectionArray = []
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
        mainView.tableView.register(BookSearchViewCell.self, forCellReuseIdentifier: BookSearchViewCell.identifier)
        mainView.tableView.prefetchDataSource = self
        bookSearchResults = bookSearchLocalRealm.objects(BookData.self)
        navigationAttribute()
        //mainView.tableView.allowsMultipleSelection = true
    }
    
    func configureUI() {
        view.addSubview(mainView.tableView) 
    }
    
    func setConstraints() {
        mainView.tableView.snp.makeConstraints { make in
            make.topMargin.equalTo(view.safeAreaLayoutGuide)
            make.bottomMargin.equalTo(view.safeAreaLayoutGuide)
            make.leadingMargin.equalTo(view.safeAreaLayoutGuide)
            make.trailingMargin.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func navigationAttribute() {
        self.navigationItem.title = "책 검색하기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        if let selectedItems = mainView.tableView.indexPathsForSelectedRows, selectedItems.count >= 1 {
            print(selectedItems)
            let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
            self.navigationItem.rightBarButtonItem = addButton
        } else {
            self.navigationItem.searchController = searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
            searchController.searchBar.delegate = self
            searchController.searchBar.placeholder = "검색"
            searchController.searchBar.searchTextField.textColor = .black
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.automaticallyShowsCancelButton = false
        }
        
        //@리팩토링: 다중선택 추가 예정
//        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
//        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonClicked() {
        //@리팩토링: 다중선택 추가 예정
        alertForBookSearch()
//        try! self.bookSearchLocalRealm.write({
//            self.bookSearchLocalRealm.add(multiselectionArray)
//        })
//        self.navigationController?.popViewController(animated: true)
    }
    
    func alertForBookSearch() {
        let alert = UIAlertController(title: "선택한 책을 추가할까요?", message: nil, preferredStyle: .alert)
        let addBook = UIAlertAction(title: "추가", style: .default) { _ in
            let bookDuplicationCheck = self.bookSearchResults.filter("ISBN == '\(self.multiselectionArray.first!.ISBN)'").count
            if bookDuplicationCheck > 0 {
                self.view.makeToast("이미 추가한 책입니다.", duration: 0.5, position: .center)
            } else {
                try! self.bookSearchLocalRealm.write({
                    self.bookSearchLocalRealm.add(self.multiselectionArray)
                })
                self.view.makeToast("선택한 책을 추가했습니다.", duration: 0.5, position: .center)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(addBook)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    func alertForBookSearch2() {
        var bookCheck = bookSearchLocalRealm.objects(BookData.self)
        let alert = UIAlertController(title: "선택한 책을 추가할까요?", message: nil, preferredStyle: .alert)
        let addBook = UIAlertAction(title: "추가", style: .default) { _ in
            if let selectedItems = self.mainView.tableView.indexPathsForSelectedRows {
                self.targetToAdd.removeAll()
                if selectedItems.count >= 1 {
                    selectedItems.forEach { indexPath in
                        self.targetToAdd.append(self.multiselectionArray[indexPath.row].ISBN)
                    }
                } else {
                    print("추가기능 비활성화")
                }
                print(self.targetToAdd)
            }
            let bookDuplicationCheck = self.bookSearchResults.filter("ISBN == '\(self.multiselectionArray.first!.ISBN)'").count
            if bookCheck.count > 0 {
                self.view.makeToast("이미 추가한 책입니다.", duration: 0.5, position: .center)
            } else {
                try! self.bookSearchLocalRealm.write({
                    self.bookSearchLocalRealm.add(self.multiselectionArray)
                })
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(addBook)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

extension BookSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let bookInfoArray = bookInfoArray else { return 0 }
        return bookInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookSearchViewCell.identifier , for: indexPath) as? BookSearchViewCell else { return UITableViewCell() }
        let url = URL(string: (bookInfoArray?[indexPath.row].image)!)
        cell.backgroundColor = .tableViewCellColor
        let replacedAuthor = bookInfoArray?[indexPath.row].author.replacingOccurrences(of: "^", with: ", ")
        cell.bookImage.kf.setImage(with: url)
        cell.bookName.text = bookInfoArray?[indexPath.row].title
        cell.bookAuthor.text = replacedAuthor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationAttribute()
        guard let items = bookInfoArray?[indexPath.row] else { return }
        guard let categorySortCode = categorySortCode else { return categorySortCode = "" }
    
        if let selectedItems = mainView.tableView.indexPathsForSelectedRows,
           selectedItems.count >= 1 {
            multiselectionArray.removeAll()
            selectedItems.forEach { indexPath in
                multiselectionArray.append(BookData(lastUpdate: Date(), categorySortCode: categorySortCode, ISBN: (bookInfoArray?[indexPath.row].isbn)!, rating: 0, review: nil, memo: nil, title: (bookInfoArray?[indexPath.row].title)!, author: (bookInfoArray?[indexPath.row].author)!, publisher: (bookInfoArray?[indexPath.row].publisher)!, pubdate: (bookInfoArray?[indexPath.row].pubdate)!, linkURL: (bookInfoArray?[indexPath.row].link)!, imageURL: (bookInfoArray?[indexPath.row].image)!))
            }
        }
        print("multiselectionArray", multiselectionArray.count, multiselectionArray)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension BookSearchViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let bookInfoArray = bookInfoArray else { return }
        for i in indexPaths {
            if bookInfoArray.count - 1 == i.row && bookInfoArray.count < self.totalCount {
                APIManager.startCount += APIManager.displayCount
                APIManager.requestBookInformation(query: searchbarText!) { [weak self] bookInfo, apiError in
                    var prefetchedData = bookInfo.map { $0.items }
                    guard let prefetchedData = prefetchedData else { return }
                    self!.bookInfoArray?.append(contentsOf: prefetchedData)
                    DispatchQueue.main.sync {
                        self!.mainView.tableView.reloadData()
                    }
                    print("Pagenation Excuted", self!.bookInfoArray)
                }
            }
        }
        
        func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
            print("Pagenation Quit===\(indexPaths)")
        }
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if NetworkConnectionChecker.shared.isConnected {
            bookInfoArray?.removeAll()
            APIManager.startCount = 1
            UserDefaults.standard.set(searchBar.text, forKey: "searchBarText")
            searchbarText = UserDefaults.standard.string(forKey: "searchBarText")
            APIManager.requestBookInformation(query: searchbarText!) { [weak self] bookInfo, apiError in
                guard let totalCount = bookInfo?.total else { return self!.totalCount = 500 }
                self!.totalCount = totalCount
                let data = bookInfo.map { $0.items }
                guard let data = data else { return }
                self!.bookInfoArray = data
                DispatchQueue.main.sync {
                    self!.mainView.tableView.reloadData()
                }
                print("searchBarTapped")
            }
        } else {
            self.view.makeToast("인터넷 연결상태를 확인해주세요.", duration: 0.5, position: .center)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textChanged")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
    }
}
