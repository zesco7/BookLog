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
    var bookInfoArray : BookInfo?
    
    init(categorySortCode: String?) {
        self.categorySortCode = categorySortCode
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
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색"
        searchController.isActive = true
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
                let record = BookData(lastUpdate: Date(), categorySortCode: categorySortCode, ISBN: isbn!, rating: 1.1, review: "1", memo: "1", title: title!, author: author!, publisher: publisher!, pubdate: Date(), linkURL: linkURL!, imageURL: imageURL!)
                try! self.bookSearchLocalRealm.write({
                    self.bookSearchLocalRealm.add(record)
                })
            } else {
                let record = BookData(lastUpdate: Date(), categorySortCode: "", ISBN: isbn!, rating: 1.1, review: "1", memo: "1", title: title!, author: author!, publisher: publisher!, pubdate: Date(), linkURL: linkURL!, imageURL: imageURL!)
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
        guard let bookInfoArray = bookInfoArray?.items else { return 0 }
        return bookInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookSearchViewCell.identifier , for: indexPath) as? BookSearchViewCell else { return UITableViewCell() }
        let url = URL(string: (bookInfoArray?.items[indexPath.row].image)!)
        cell.backgroundColor = .clear
        cell.bookImage.kf.setImage(with: url)
        cell.bookName.text = bookInfoArray?.items[indexPath.row].title
        cell.bookAuthor.text = bookInfoArray?.items[indexPath.row].author
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //multiselection은 배열에 append해서 처리예정
        let items = bookInfoArray?.items[indexPath.row]
        UserDefaults.standard.set(items?.isbn, forKey: "isbn")
        UserDefaults.standard.set(items?.title, forKey: "title")
        UserDefaults.standard.set(items?.author, forKey: "author")
        UserDefaults.standard.set(items?.publisher, forKey: "publisher")
        UserDefaults.standard.set(items?.pubdate, forKey: "pubdate")
        UserDefaults.standard.set(items?.link, forKey: "linkURL")
        UserDefaults.standard.set(items?.image, forKey: "imageURL")
        alertForBookSearch()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //서치바 입력내용으로 네트워크통신요청 후 받은데이터 bookSearchResults에 넣어서 셀재사용 처리
        APIManager.requestBookInformation(query: searchBar.text!) { bookInfo, apiError in
            self.bookInfoArray = bookInfo.map { $0 }
            print(self.bookInfoArray)
            DispatchQueue.main.sync {
                self.mainView.tableView.reloadData()
            }
        //검색어 입력하고 결과나오면 서치바 내려가고 네비게이션버바버튼에 완료버튼 생성
        //완료버튼 누르면 다시 네비게이션바버튼 올라가고 검색어 입력창 활성화
            print("searchBarTapped")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textChanged")
    }
}
