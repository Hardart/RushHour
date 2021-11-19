//
//  TabBarVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.11.2021.
//

import UIKit
import FirebaseAuth

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .systemGray4
        tabBar.tintColor = .label
        tabBar.backgroundColor = .systemGray6
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let controls = [UINavigationController(rootViewController: ConversationVC()),
                        UINavigationController(rootViewController: ContactsVC()),
                        UINavigationController(rootViewController: AppConfigVC())]
        let titlesForControls = ["Чаты", "Контакты", "Настройки"]
        let iconsForControls = ["bubble.left.and.bubble.right.fill", "person.crop.circle", "gear"]
        
        setViewControllers(controls, animated: false)
        
        guard let items = tabBar.items else {return}
        for i in 0..<controls.count{
            controls[i].title = titlesForControls[i]
            items[i].image = UIImage(systemName: iconsForControls[i])
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginVC()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    

}
