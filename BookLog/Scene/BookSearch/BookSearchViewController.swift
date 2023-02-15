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
    var selectionSet = Set<BookData>()
    var duplicatedBooks = Set<String>()
    var searchbarText : String?
    var totalCount = 0
    let searchController = UISearchController(searchResultsController: nil)
    
    init(categorySortCode: String?) {
        self.categorySortCode = categorySortCode
        self.selectionSet = []
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
//        mainView.tableView.allowsMultipleSelection = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
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
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.searchTextField.textColor = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
    }
    
    func alertForBookSearch() {
        let alert = UIAlertController(title: "선택한 책을 추가할까요?", message: nil, preferredStyle: .alert)
        let addBook = UIAlertAction(title: "추가", style: .default) { _ in
            let bookDuplicationCheck = self.bookSearchResults.filter("ISBN == '\(self.selectionSet.first!.ISBN)'").count
            if bookDuplicationCheck > 0 {
                self.view.makeToast("이미 추가한 책입니다.", duration: 0.5, position: .center)
            } else {
                try! self.bookSearchLocalRealm.write({
                    self.bookSearchLocalRealm.add(self.selectionSet)
                })
                self.view.makeToast("선택한 책을 추가했습니다.", duration: 0.5, position: .center)
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
        guard let bookInfoArray = bookInfoArray else { return UITableViewCell() }
        var isbn = bookInfoArray[indexPath.row].isbn
        
        if duplicatedBooks.contains(isbn) {
            cell.backgroundColor = .selectionColor
        } else {
            cell.backgroundColor = .tableViewCellColor
        }
        
        let url = URL(string: (bookInfoArray[indexPath.row].image))
        cell.bookImage.kf.setImage(with: url)
        cell.bookName.text = bookInfoArray[indexPath.row].title
        cell.bookAuthor.text = bookInfoArray[indexPath.row].replacedAuthor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alertForBookSearch()
        guard let items = bookInfoArray?[indexPath.row] else { return }
        guard let categorySortCode = categorySortCode else { return categorySortCode = "" }
        selectionSet.insert(items.toBookData(lastUpate: Date(), categorySortCode: categorySortCode, review: nil, memo: nil))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectionSet.removeAll()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let bookInfoArray = bookInfoArray else { return indexPath }
        var isbn = bookInfoArray[indexPath.row].isbn
        if duplicatedBooks.contains(isbn) {
            return nil
        } else {
            return indexPath
        }
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
                        self!.bookInfoArray?.forEach({ item in
                            var isDuplicatedBooks = self!.bookSearchLocalRealm.object(ofType: BookData.self, forPrimaryKey: item.isbn) != nil
                            if isDuplicatedBooks {
                                self!.duplicatedBooks.insert(item.isbn)
                            }
                        })
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
                    self!.bookInfoArray?.forEach({ item in
                        var isDuplicatedBooks = self!.bookSearchLocalRealm.object(ofType: BookData.self, forPrimaryKey: item.isbn) != nil
                        if isDuplicatedBooks {
                            self!.duplicatedBooks.insert(item.isbn)
                        }
                    })
                    print("저장된 책", self!.duplicatedBooks)
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
