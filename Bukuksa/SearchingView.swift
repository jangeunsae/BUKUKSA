//
//  SearchingView.swift
//  Bukuksa
//
//  Created by 장은새 on 7/15/25.
//


import Foundation

import UIKit
import SnapKit

class SearchingView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private let searchTextField = UITextField()
    private let resultsTableView = UITableView()
    private let collectionViewCell = UICollectionViewCell()
    private var searchResults: [String] = []
    private let allSearchLists = ["a", "b", "c", "d"]
    //collectionViewcell이 만들어져서 밑에 연관검색어와 연결되는 영화목록이 떠야함
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(searchTextField)
        addSubview(resultsTableView)
        
        searchTextField.backgroundColor = .lightGray
        searchTextField.delegate = self
        searchTextField.becomeFirstResponder()
        searchTextField.borderStyle = .line
        searchTextField.keyboardType = .default
        searchTextField.placeholder = "Search"
        
        searchTextField.isHidden = true
        
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.isHidden = true
        
        resultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        
        resultsTableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        filterSearchResults(text: updatedText)
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextField.text = searchResults[indexPath.row]
        resultsTableView.isHidden = true
        searchResults = []
        resultsTableView.reloadData()
    }
    
    func filterSearchResults(text: String) {
        searchResults = allSearchLists.filter { $0.lowercased().hasPrefix(text.lowercased()) }
        resultsTableView.isHidden = searchResults.isEmpty
        resultsTableView.reloadData()
    }
    
    
    public func showSearchTextField() {
        searchTextField.isHidden = false
        resultsTableView.isHidden = false
    }
    
    public func hideSearchTextField() {
        searchTextField.isHidden = true
        resultsTableView.isHidden = true
    }
}
