//
//  TableHeaderForConfigVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 23.11.2021.
//

import UIKit
import SDWebImage

class ConfigHeaderView: UIView {

    private let profileImageView = UIImageView()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
//        backgroundColor = .systemGray5
        setupProfileImageLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureWithURL(imageURL: URL) {
        profileImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "person.circle.fill"))
    }
    
    public func configureWithImage(image: UIImage) {
        profileImageView.image = image
    }
    
    private func setupProfileImageLayouts() {
        let imageSize: CGFloat = 0.8
        addSubview(profileImageView)
        profileImageView.anchors(
            centerX: centerXAnchor,
            centerY: centerYAnchor,
            width: heightAnchor,
            widthMultiplayer: imageSize,
            height: heightAnchor,
            heightMultiplayer: imageSize
        )
        profileImageView.layoutIfNeeded()
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.width / 2
        profileImageView.contentMode = .scaleAspectFill
    }
    
    
}
