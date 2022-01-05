//
//  NewConversationVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 20.11.2021.
//

import UIKit

class StartNewConversationVC: UIViewController {
    
    //MARK: - Элементы
    private var users = [[String: String]]()
    
    private var hasFetched = false

    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Поиск"
        return search
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
//        view.isHidden = true
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    let emptyViewLabel = HiddenTextLabel()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Отменить",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tapCancelButton))
        
        setupTableView()
        setupNoViewText()
        searchBar.becomeFirstResponder()
    }
    
    //MARK: - Selectors
    @objc func tapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Private methods
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.anchors(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
//        tableView.isHidden = true
    }
    
    fileprivate func setupNoViewText(){
        view.addSubview(emptyViewLabel)
        emptyViewLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        emptyViewLabel.text = "Нет контактов"
        emptyViewLabel.isHidden = true
    }
}


extension StartNewConversationVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        
        searchUsers(query: searchText)
    }
    
    func searchUsers(query: String) {
        if hasFetched {
            
        } else {
            
        }
    }
}


extension StartNewConversationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
    }
    
//    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Абашин Олег"
//        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
