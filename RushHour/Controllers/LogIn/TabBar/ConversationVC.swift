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
    
    //MARK: - Элементы
    private let spinner = JGProgressHUD(style: .dark)
    
    public var conversationsList = [Conversation]()
    
    public let tableView: UITableView = {
        let view = UITableView()
        view.register(ConversationsTVC.self, forCellReuseIdentifier: ConversationsTVC.id)
        return view
    }()

    let emptyViewLabel = HiddenTextLabel()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        title = "Чаты"
        spinner.position = .center
        spinner.layer.zPosition = 1
        spinner.show(in: view, animated: true)
        
        setupNoViewText()
        setupTableView()
        conversationObserver()
        
        

//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .systemGray6
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapComposeButton))
        navigationController?.navigationBar.prefersLargeTitles = true
//        DatabaseManager.shared.getUsers()
    }
    
    //MARK: - LayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    //MARK: - SetupTableView
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    //MARK: - Private methods
    fileprivate func createNewConversation(result: [String: String]) {
        guard let name = result["name"], let uid = result["uid"] else {return}
        let vc = ChatVC(with: uid, and: nil)
        vc.title = name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func setupNoViewText(){
        view.addSubview(emptyViewLabel)
        emptyViewLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        emptyViewLabel.text = "Нет ни одного диалога"
        emptyViewLabel.isHidden = false
        spinner.dismiss(animated: false)
    }
    
    fileprivate func noConversations(value: Bool) {
        if value {
            emptyViewLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyViewLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    fileprivate func conversationObserver() {
        guard let userData = UserDataCache.shared.getUserData() else { return }
        let userUID = userData.uid
        DatabaseManager.shared.getAllConversations(for: userUID, completion: {[weak self] result in
            switch result {
            case .success(let conversations):
                
                DispatchQueue.main.async {
                    self?.spinner.dismiss(animated: false)
                    self?.conversationsList = conversations
                    self?.noConversations(value: false)
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.spinner.dismiss(animated: false)
                    
                }
                if error == DatabaseErrors.pathDoesNotExist {
                    self?.noConversations(value: true)
                    self?.tableView.reloadData()
                }
            }
        })
    }
    
    //MARK: - Selectors
    @objc func tapComposeButton() {
        let vc = StartNewConversationVC()
        vc.completion = { [weak self] result in
            self?.createNewConversation(result: result)
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

//MARK: - Extensions
extension ConversationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationsList.count
    }
    
//    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationsTVC.id, for: indexPath) as! ConversationsTVC
        cell.configure(with: conversationsList[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversation = conversationsList[indexPath.row]
        let vc = ChatVC(with: conversation.recipient_uid, and: conversation.id)
        vc.title = conversation.recipient_name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
