//
//  SearchEntireBookListViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2023/01/01.
//

import UIKit

class SearchEntireBookListViewController: BaseViewController {
    var mainView = SearchEntireBookListView()
    
    override func loadView() {
        self.view = mainView
    }
    
    var bookList = ["1", "2"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(SearchEntireBookListViewCell.self, forCellReuseIdentifier: SearchEntireBookListViewCell.identifier)
        mainView.tableView.allowsMultipleSelection = true
        navigationAttribute()
        
    }
    
    func navigationAttribute() {
        self.navigationItem.title = "ㅎㅎㅎ"
        let completionButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(completionButtonClicked))
        self.navigationItem.rightBarButtonItem = completionButton
    }
    
    @objc func completionButtonClicked() {
        self.dismiss(animated: true)
    }
    
}

extension SearchEntireBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchEntireBookListViewCell.identifier , for: indexPath) as? SearchEntireBookListViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        
        cell.bookName.text = bookList[indexPath.row]
//        cell.bookAuthor.text = bookList[indexPath.row].author
//        cell.bookRating.text = "\(bookList[indexPath.row].rating!)"
//        cell.bookReview.text = bookList[indexPath.row].review
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
    }
