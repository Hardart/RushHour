//
//  ConversationVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.11.2021.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationVC: UIViewController {
    
    private let tableView: UITableView = {
        let view = UITableView()
//        view.isHidden = true
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return view
    }()
    
    let emptyViewLabel = HiddenTextLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        title = "Чаты"
        
        
        
//
        
        setupTableView()
        startNewConversation()
        setupNoViewText()
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .systemGray6
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func startNewConversation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(createNewConversation))
    }
    
    @objc func createNewConversation() {
        let vc = NewConversationVC()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    func setupNoViewText(){
        view.addSubview(emptyViewLabel)
        emptyViewLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        emptyViewLabel.text = "Нет ни одного диалога"
        emptyViewLabel.isHidden = true
    }
    
}

extension ConversationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
    }
    
//    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Шакирова Юля"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatVC()
        vc.title = "Шакирова Юля"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
