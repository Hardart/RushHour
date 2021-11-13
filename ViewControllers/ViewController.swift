//
//  ViewController.swift
//  RushHour
//
//  Created by Артем Шакиров on 10.11.2021.
//

import UIKit

class ViewController: UIViewController {
    let button = TwoLinesButton()
    let button2 = TwoLinesButton()
    var changeCol = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        navigationItem.title = "Home"
        
        
       
        
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        button2.addTarget(self, action: #selector(changeColor), for: .touchUpInside)
        
        setButtonAnchor()
        setButton2Anchor()
        
        
        //MARK: создание хэдера
        navigationController?.navigationBar.tintColor = .label
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray2
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        //        navigationController?.navigationBar.standardAppearance = appearance
        //        navigationController?.navigationBar.compactAppearance = appearance
        
        configurationNavigationButtons()
        
    }
    
    @objc private func didTap() {
        let vc = RegisterVewController()
//        navigationController?.pushViewController(vc, animated: true)
        vc.modalPresentationStyle = .popover
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func changeColor(){
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
    
    
    //MARK: создание навигационных кнопок
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
    
    //MARK: создание кнопок
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

