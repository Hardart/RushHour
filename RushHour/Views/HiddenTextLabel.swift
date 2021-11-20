//
//  HiddenTextLabel.swift
//  RushHour
//
//  Created by Артем Шакиров on 20.11.2021.
//

import UIKit

class HiddenTextLabel: UILabel {
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        textAlignment = .center
        textColor = .gray
        font = .systemFont(ofSize: 24, weight: .medium)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
