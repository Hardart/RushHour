//
//  TextFieldTemplate.swift
//  RushHour
//
//  Created by Артем Шакиров on 19.11.2021.
//

import UIKit

class TextFieldTemplate: UITextField {

    override init(frame: CGRect) {
        super .init(frame: frame)
        
       autocapitalizationType = .none
       autocorrectionType = .no
       returnKeyType = .continue
       backgroundColor = .systemGray6
       layer.cornerRadius = 6
       layer.borderWidth = 1
       leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
       leftViewMode = .always
       layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
