//
//  BookSearchViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/01.
//

import UIKit
import RealmSwift

class BookSearchViewController: BaseViewController {
    var mainView = BookSearchView()
    var bookSearchResults : [Int] = []
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(EntireBookListViewCell.self, forCellReuseIdentifier: EntireBookListViewCell.identifier)

        navigationAttribute()
        //hideKeyboard()
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EntireBookListViewCell.identifier , for: indexPath) as? EntireBookListViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.bookName.text = "\(bookSearchResults[indexPath.row])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        alertForBookSearch()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension BookSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //서치바 입력내용으로 네트워크통신요청 후 받은데이터 bookSearchResults에 넣어서 셀재사용 처리
        bookSearchResults = Array(repeating: 10, count: 20)
        mainView.tableView.reloadData()
        print("searchBarTapped")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textChanged")
    }
}
