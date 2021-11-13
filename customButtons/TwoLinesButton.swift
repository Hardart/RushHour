//
//  TwoLinesButton.swift
//  RushHour
//
//  Created by Артем Шакиров on 10.11.2021.
//

import UIKit

struct TwoLinesButtonModel {
    let primaryText: String
    let secondaryText: String
}

class TwoLinesButton: UIButton {
    
    private let primaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubview(primaryLabel)
        addSubview(secondaryLabel)
        clipsToBounds = true
        backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with viewModel: TwoLinesButtonModel) {
        primaryLabel.text = viewModel.primaryText
        secondaryLabel.text = viewModel.secondaryText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        primaryLabel.frame = CGRect(
            x: 0,
            y: 2,
            width: frame.size.width,
            height: frame.size.height/2
        )
        secondaryLabel.frame = CGRect(
            x: 0,
            y: frame.size.height/2,
            width: frame.size.width,
            height: frame.size.height/2
        )
    }
    
}
