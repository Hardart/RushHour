//
//  TabBarVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.11.2021.
//

import UIKit
import FirebaseAuth

class TabBarVC: UITabBarController {
    
    let blackView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .systemGray4
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemGray6
        
        blackView.backgroundColor = .systemGray
        blackView.layer.zPosition = 1
        blackView.frame = view.bounds
        view.addSubview(blackView)
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configVC = AppConfigVC()
        let convoVC = ConversationVC()
        
        if let userData = UserDataCache.shared.getUserData() {
            
            
            DatabaseManager.shared.getUser(by: userData.uid) {user in
                configVC.userData = user
                
                
            }
            DatabaseManager.shared.getAllConversations(for: userData.uid, completion: {[weak self] result in
                guard let view = self?.view else { return }
                configVC.imageProfile = UserDataCache.shared.setupHeaderView(urlString: userData.imageURL, view: view)
                switch result {
                case .success(let conversations):
                    DispatchQueue.main.async {
                        convoVC.conversationsList = conversations
                        convoVC.tableView.reloadData()
                        
                        UIView.animate(withDuration: 0.5) {[weak self] in
                            self?.blackView.alpha = 0
                        }
                    }
                case .failure(let error):
                    UIView.animate(withDuration: 0.2) {[weak self] in
                        self?.blackView.alpha = 0
                    }
                    if error == DatabaseErrors.pathDoesNotExist {
                        
                    }
                }
                
            })
            
        } else {
            print("No userUID in TabBarVC error")
            UIView.animate(withDuration: 0.5) {[weak self] in
                self?.blackView.alpha = 0
            }
        }
        
  
        configVC.title = "Настройки профиля"
        
        
        let controls = [UINavigationController(rootViewController: convoVC),
                        UINavigationController(rootViewController: ContactsVC()),
                        UINavigationController(rootViewController: configVC)]
        let titlesForControls = ["Чаты", "Контакты", "Настройки"]
        let iconsForControls = ["bubble.left.and.bubble.right.fill", "person.crop.circle", "gear"]
        
        setViewControllers(controls, animated: false)
        
        guard let items = tabBar.items else {return}
        for i in 0..<controls.count{
            controls[i].title = titlesForControls[i]
            items[i].image = UIImage(systemName: iconsForControls[i])
        }
        
        selectedIndex = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
    }
    
    
}
