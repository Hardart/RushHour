//
//  HomeVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.11.2021.
//

import UIKit

class ContactsVC: UIViewController {
    
    let emptyViewLabel = HiddenTextLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        title = "Контакты"
        
        createNewContact()
        setupNoViewText()
    }
    
    
    func setupNoViewText(){
        view.addSubview(emptyViewLabel)
        emptyViewLabel.anchors(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
        emptyViewLabel.text = "Нет контактов"
    }
    
    func createNewContact() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
    }
    
    @objc func tapAddButton(){
        
    }

}



