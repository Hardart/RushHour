//
//  AppConfigVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.11.2021.
//

import UIKit
import FirebaseAuth

class AppConfigVC: UIViewController {
    
    let tableView = UITableView()
    
    let emptyViewLabel = HiddenTextLabel()
    
    public var imageProfile: UIView?
    public var userData: UserShortData?

    //MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewLayout()
        configurationNavigationButtons()
        setupNoViewText()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userData = UserDataCache.shared.getUserData() {
            imageProfile = UserDataCache.shared.setupHeaderView(urlString: userData.imageURL, view: view)
            tableView.tableHeaderView = imageProfile
            DatabaseManager.shared.getUser(by: userData.uid) {[weak self] user in
                self?.userData = user
                self?.tableView.reloadData()
            }
        }
        
    }
    
    func tableViewLayout(){
        view.addSubview(tableView)
        tableView.anchors(
            top: view.topAnchor,
            left: view.leftAnchor,
            bottom: view.bottomAnchor,
            right: view.rightAnchor
        )
        tableView.isHidden = false
        tableView.backgroundColor = .systemGray5
    }
    
    func setupNoViewText(){
        view.addSubview(emptyViewLabel)
        emptyViewLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        emptyViewLabel.text = "Экран пока не настроен"
        emptyViewLabel.isHidden = true
    }
    
    func configurationNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Выйти", style: .done, target: self, action: #selector(tapLogOut))
    }
    
    @objc func tapLogOut(){
        do {
            try FirebaseAuth.Auth.auth().signOut()
            let vc = LoginVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        } catch {
            print("Something wrong")
        }
    }
}

extension AppConfigVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = userData?.name
        cell.backgroundColor = .systemGray5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
