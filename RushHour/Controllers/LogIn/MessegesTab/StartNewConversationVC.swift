//
//  NewConversationVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 20.11.2021.
//

import UIKit
import JGProgressHUD

class StartNewConversationVC: UIViewController {
    
    //MARK: - Элементы
    private var users = [[String:String]]()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var searchResult = [[String:String]]()
    
    public var completion: (([String:String])->(Void))?
    
    private var hasFetched = false
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Поиск"
        return search
    }()
    
    private let tableView: UITableView = {
        let view = UITableView()
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
    }
    
    fileprivate func setupNoViewText(){
        view.addSubview(emptyViewLabel)
        emptyViewLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        emptyViewLabel.text = "Нет контактов"
        emptyViewLabel.isHidden = true
    }
}


extension StartNewConversationVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchResult.removeAll()
            tableView.isHidden = true
            emptyViewLabel.isHidden = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        spinner.show(in: view, animated: true)
        searchResult.removeAll()
        searchUsers(query: searchText.replacingOccurrences(of: " ", with: ""))
    }
    
    func searchUsers(query: String) {
        if hasFetched {
            filterUsers(query)
        } else {
            DatabaseManager.shared.getAllFromUsersCollection(completion: {[weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(query)
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            })
        }
    }
    
    func filterUsers(_ by: String) {
        guard hasFetched else { return }
        self.spinner.dismiss(afterDelay: 0, animated: false) { [weak self] in
            guard let self = self else { return }
            let result: [[String: String]] = self.users.filter({
                guard let name = $0["name"]?.lowercased() else { return false }
                return name.hasPrefix(by.lowercased())
            })
            self.searchResult = result
            self.updateView()
        }
    }
    
    func updateView() {
        if searchResult.isEmpty {
            self.emptyViewLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            self.emptyViewLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}


extension StartNewConversationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    //    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResult[indexPath.row]["name"]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true , completion: { [unowned self] in
            self.completion?(searchResult[indexPath.row])
        })
        
    }
    
    
}
