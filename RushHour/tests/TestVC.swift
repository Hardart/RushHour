//
//  ViewController.swift
//  RushHour
//
//  Created by Артем Шакиров on 10.11.2021.
//

import UIKit

class TestVC: UIViewController {
    
    let button = TwoLinesButton()
    let button2 = TwoLinesButton()
    var changeCol = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        navigationItem.title = "Home"
        
        
        
        button.addTarget(self, action: #selector(didTapButton1), for: .touchUpInside)
        button2.addTarget(self, action: #selector(didTapButton2), for: .touchUpInside)
        
        setButtonAnchor()
        setButton2Anchor()
        configurationNavigationButtons()
        
    }
    
    //MARK: - Обрабатываем нажатие кнопок
    @objc private func didTapButton1() {
        let vc = RegisterVC()
//        navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func didTapButton2(){
        if changeCol {
            UIView.animate(withDuration: 0.15) {
                self.button2.backgroundColor = .cyan
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                self.button2.backgroundColor = .systemRed
            }
        }
        
        changeCol = !changeCol
    }
    
    //MARK: -структура в строку
    func structToString() {
//        let lastMessage = LastMessage(date: Date(), last_message: "Test String", is_read: false)
//        let conv = Conversation(id: UUID().uuidString, sender_uid: "kjsfdhsgh", latest_message: lastMessage)
//        let user = ChatAppUser(nick_name: "roy", first_name: "Cross", last_name: "Last", email: "asfaf", conversations: conv)
//        let newUser = try? user.asDictionary()
    }
    
    func dateString(from date: Date) -> String {
        let dateFormatter: DateFormatter = {
            let format = DateFormatter()
            format.dateFormat = "MM.dd.yyyy HH:mm:ss"
            format.timeZone = .current
            return format
        }()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    //MARK: -создание навигационных кнопок
    func configurationNavigationButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                barButtonSystemItem: .trash,
                target: self,
                action: nil),
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: nil),
        ]
    }
    
    //MARK: -создание кнопок
    func setButtonAnchor(){
        button.config(with: TwoLinesButtonModel(primaryText: "Hello", secondaryText: "World"))
        
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25.5).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setButton2Anchor(){
        button2.config(with: TwoLinesButtonModel(primaryText: "Hellooo", secondaryText: "World"))
        
        button2.backgroundColor = .systemRed
        button2.layer.cornerRadius = 10
        button2.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.addSubview(button2)
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button2.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25.5).isActive = true
        button2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        button2.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}


