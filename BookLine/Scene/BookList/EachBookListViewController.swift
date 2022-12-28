//
//  EachBookListViewController.swift
//  BookLine
//
//  Created by Mac Pro 15 on 2022/12/28.
//

import UIKit
import RealmSwift

class EachBookListViewController: BaseViewController {
    var mainView = EachBookListView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.register(EachBookListViewCell.self, forCellReuseIdentifier: "EachBookListViewCell")
        
        navigationAttribute()
    }
    
    func navigationAttribute() {
        //self.navigationItem.title = "모든 책" //realm에 저장한 카테고리 이름이 네비타이틀로 사용됨
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        self.navigationItem.rightBarButtonItems = [plusButton, sortButton]
    }
    
    @objc func sortButtonClicked() {
        //제목순, 별점순, 최종작성날짜순 선택목록 표시
    }
    
    @objc func plusButtonClicked() {
        //책추가 옵션 표시
        actionSheetForBookSearch()
    }
    
    func actionSheetForBookSearch() {
        let actionSheet = UIAlertController(title: "원하는 책을 찾아보세요", message: nil, preferredStyle: .actionSheet)
        let searchingForNewBook = UIAlertAction(title: "새 책 찾기", style: .default) //새 책 찾기 선택시 책검색화면으로 이동
        let searchingForSavedBook = UIAlertAction(title: "저장된 책에서 찾기", style: .default) //저장된 책찾기 선택시 "모든 책" 카테고리로 이동
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        actionSheet.addAction(searchingForNewBook)
        actionSheet.addAction(searchingForSavedBook)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
}

extension EachBookListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EachBookListViewCell", for: indexPath) as? EachBookListViewCell else { return UITableViewCell() }
        
        cell.bookName.text = "저승 가는 길에는 목욕탕이 있다"
        cell.bookAuthor.text = "마카롱"
        cell.bookRating.text = "5.0"
        cell.bookReview.text = "우주 안에 무한한 소우주가 존재하듯 인간의 사념도 수 갈래의 하늘과 땅을 만들고, 어느 저승도 그렇게 탄생했다. 이 이야기로 죽음 너머의 한 세계를 소개하려 한다."
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

