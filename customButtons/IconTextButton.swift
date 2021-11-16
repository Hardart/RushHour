//
//  iconTextButton.swift
//  RushHour
//
//  Created by Артем Шакиров on 10.11.2021.
//

import UIKit

struct IconButtonModel {
    let icon: UIImage?
    let title: String
    let background: UIColor?
    let iconSize: CGFloat
    let spaceBetween: CGFloat
}

final class IconTextButton: UIButton {
    
    private var iconSize = CGFloat()
    private var elementSpace = CGFloat()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        return icon
        
    }()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubview(label)
        addSubview(iconImage)
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(with viewModel: IconButtonModel) {
        label.text = viewModel.title
        iconImage.image = viewModel.icon
        iconSize = viewModel.iconSize
        elementSpace = viewModel.spaceBetween
        backgroundColor = viewModel.background
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        
        let iconX: CGFloat = (frame.size.width - label.frame.size.width - iconSize - elementSpace) / 2
        iconImage.frame = CGRect(
            x: iconX,
            y: (frame.size.height - iconSize)/2,
            width: iconSize,
            height: iconSize
        )
        
        label.frame = CGRect(
            x: iconX + iconSize + elementSpace,
            y: 0,
            width: label.frame.size.width,
            height: frame.size.height
        )
    }
    
}
