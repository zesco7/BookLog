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
    var categorySortCodeForBookSearch : [String] = []
    var categorySortCode : String?
    var bookInfoArray : [Item]?
    var multiselectionArray : Array<Item>
    var searchbarText : String?
    var totalCount = 0

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
        mainView.tableView.allowsMultipleSelection = true
        //hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("카테고리구분:", categorySortCode)
    }
    
    func navigationAttribute() {
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.title = "책 검색하기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        let addButton = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonClicked))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
    }
    
    @objc func addButtonClicked() {
        if let categorySortCode = self.categorySortCode {
            try! self.bookSearchLocalRealm.write({
                for i in 0...(multiselectionArray.count - 1) {
                    print("추가할 레코드: ", self,multiselectionArray[i])
                    //self.bookSearchLocalRealm.add(self.multiselectionArray[i])
                }
            })
        } else {
//            let record = BookData(lastUpdate: Date(), categorySortCode: "", ISBN: isbn!, rating: nil, review: nil, memo: nil, title: title!, author: author!, publisher: publisher!, pubdate: Date(), linkURL: linkURL!, imageURL: imageURL!)
//            try! self.bookSearchLocalRealm.write({
//                self.bookSearchLocalRealm.add(record)
//            })
        }
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alertForBookSearch() {
        let alert = UIAlertController(title: "선택한 책을 추가할까요?", message: nil, preferredStyle: .alert)
        let addBook = UIAlertAction(title: "추가", style: .default) { _ in
            //선택한 row데이터를 realm에 저장(이 때 categorySortCode는 이전화면에서 받은 값을 저장)
            let isbn = UserDefaults.standard.string(forKey: "isbn")
            let title = UserDefaults.standard.string(forKey: "title")
            let author = UserDefaults.standard.string(forKey: "author")
            let publisher = UserDefaults.standard.string(forKey: "publisher")
            let pubdate = UserDefaults.standard.string(forKey: "pubdate")
            let linkURL = UserDefaults.standard.string(forKey: "linkURL")
            let imageURL = UserDefaults.standard.string(forKey: "imageURL")
            
            //rating, review, memo 값 처리 예정
            if let categorySortCode = self.categorySortCode {
                let record = BookData(lastUpdate: Date(), categorySortCode: categorySortCode, ISBN: isbn!, rating: nil, review: nil, memo: nil, title: title!, author: author!, publisher: publisher!, pubdate: Date(), linkURL: linkURL!, imageURL: imageURL!)
                try! self.bookSearchLocalRealm.write({
                    self.bookSearchLocalRealm.add(record)
                })
            } else {
                let record = BookData(lastUpdate: Date(), categorySortCode: "", ISBN: isbn!, rating: nil, review: nil, memo: nil, title: title!, author: author!, publisher: publisher!, pubdate: Date(), linkURL: linkURL!, imageURL: imageURL!)
                try! self.bookSearchLocalRealm.write({
                    self.bookSearchLocalRealm.add(record)
                })
            }
            self.navigationController?.popViewController(animated: true)
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
        cell.backgroundColor = .clear
        cell.bookImage.kf.setImage(with: url)
        cell.bookName.text = bookInfoArray?[indexPath.row].title
        cell.bookAuthor.text = bookInfoArray?[indexPath.row].author
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //multiselection은 배열에 append해서 처리예정
        guard let items = bookInfoArray?[indexPath.row] else { return }
        multiselectionArray.append(items)
        UserDefaults.standard.set(items.isbn, forKey: "isbn")
        UserDefaults.standard.set(items.title, forKey: "title")
        UserDefaults.standard.set(items.author, forKey: "author")
        UserDefaults.standard.set(items.publisher, forKey: "publisher")
        UserDefaults.standard.set(items.pubdate, forKey: "pubdate")
        UserDefaults.standard.set(items.link, forKey: "linkURL")
        UserDefaults.standard.set(items.image, forKey: "imageURL")
        print(multiselectionArray)
        alertForBookSearch()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
            print("===\(indexPaths)")
        }
        
        func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
            print("취소===\(indexPaths)")
        }
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        bookInfoArray?.removeAll()
        APIManager.startCount = 1
        UserDefaults.standard.set(searchBar.text, forKey: "searchBarText")
        searchbarText = UserDefaults.standard.string(forKey: "searchBarText")
        APIManager.requestBookInformation(query: searchbarText!) { [weak self] bookInfo, apiError in
            self!.totalCount = (bookInfo?.total)!
            var data = bookInfo.map { $0.items }
            guard let data = data else { return }
            self!.bookInfoArray = data
            print(self!.bookInfoArray)
            DispatchQueue.main.sync {
                self!.mainView.tableView.reloadData()
            }
            print("searchBarTapped")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textChanged")
    }
}
