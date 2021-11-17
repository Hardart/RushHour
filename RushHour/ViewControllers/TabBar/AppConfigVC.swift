//
//  AppConfigVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.11.2021.
//

import UIKit

class AppConfigVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
        configurationNavigationButtons()
    }
    
    func configurationNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Выйти", style: .done, target: nil, action: nil)
    
    }
}
