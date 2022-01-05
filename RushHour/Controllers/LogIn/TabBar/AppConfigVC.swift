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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray5
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = setupHeaderView()
        
        tableViewLayout()
        configurationNavigationButtons()
        setupNoViewText()
        
    }
    
    func setupHeaderView() -> UIView? {
        
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return nil
//        }
        
//        let imageName = DatabaseManager.safeEmail(email) + "_profile_image.png"
//        let path = "images/" + imageName
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: 200))
        header.backgroundColor = .systemGray4
        
        let imageView = UIImageView()
        let imageSize: CGFloat = 0.6
        
        header.addSubview(imageView)
        imageView.anchors(
            centerX: header.centerXAnchor,
            centerY: header.centerYAnchor,
            width: header.heightAnchor,
            widthMultiplayer: imageSize,
            height: header.heightAnchor,
            heightMultiplayer: imageSize
        )
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = header.height * imageSize / 2
        imageView.contentMode = .scaleAspectFill
        return header
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
        cell.textLabel?.text = "Строка"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
