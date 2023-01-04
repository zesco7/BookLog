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
            
            //선택한 row의 값이 바뀌도록 어떻게? 첫번째 값만 계속바뀜.
            let record = self.bookSearchLocalRealm.objects(BookData.self).first
            
            try! self.bookSearchLocalRealm.write({
                record?.categorySortCode = self.categorySortCode!
                self.mainView.tableView.reloadData()
            })
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(addBook)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}

extension BookSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookSearchViewCell.identifier , for: indexPath) as? BookSearchViewCell else { return UITableViewCell() }
        let url = URL(string: bookSearchResults[indexPath.row].imageURL)
        cell.backgroundColor = .clear
        cell.bookImage.kf.setImage(with: url)
        cell.bookName.text = "\(bookSearchResults[indexPath.row].title)"
        cell.bookAuthor.text = "\(bookSearchResults[indexPath.row].author)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alertForBookSearch()
//        let categorySortCode = self.bookSearchLocalRealm.objects(BookData.self).first!
//        print(categorySortCode.categorySortCode.first[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //서치바 입력내용으로 네트워크통신요청 후 받은데이터 bookSearchResults에 넣어서 셀재사용 처리
        APIManager.requestBookInformation(query: searchBar.text!) { bookInfo, apiError in
            dump(bookInfo!)
            //하위 struct에 접근 어떻게?
            //구조체를 통채로 배열에 넣는거 어떻게?
            UserDefaults.standard.set(bookInfo?.items.first?.isbn, forKey: "isbn")
            UserDefaults.standard.set(bookInfo?.items.first?.title, forKey: "title")
            UserDefaults.standard.set(bookInfo?.items.first?.author, forKey: "author")
            UserDefaults.standard.set(bookInfo?.items.first?.publisher, forKey: "publisher")
            UserDefaults.standard.set(bookInfo?.items.first?.pubdate, forKey: "pubdate")
            UserDefaults.standard.set(bookInfo?.items.first?.link, forKey: "linkURL")
            UserDefaults.standard.set(bookInfo?.items.first?.image, forKey: "imageURL")
            
            let isbn = bookInfo?.items.first?.isbn
            let title = bookInfo?.items.first?.title
            let author = bookInfo?.items.first?.author
            let publisher = bookInfo?.items.first?.publisher
            let pubdate = bookInfo?.items.first?.pubdate
            let linkURL = bookInfo?.items.first?.link
            let imageURL = bookInfo?.items.first?.image

            DispatchQueue.main.sync {
                let record = BookData(lastUpdate: Date(), categorySortCode: "", ISBN: isbn!, rating: 1.1, review: "1", memo: "1", title: title!, author: author!, publisher: publisher!, pubdate: Date(), linkURL: linkURL!, imageURL: imageURL!) //Realm 레코드 생성

                try! self.bookSearchLocalRealm.write({
                    self.bookSearchLocalRealm.add(record)
                })
                self.mainView.tableView.reloadData()
                print("searchBarTapped")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textChanged")
    }
}
