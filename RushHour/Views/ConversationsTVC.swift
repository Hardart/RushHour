//
//  ConversationsTVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.12.2021.
//

import UIKit

class ConversationsTVC: UITableViewCell {
    
    static let id = "ConversationsTVC"
    
    private let userProfileImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 2
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(userProfileImageView)
        userProfileImageView.anchors(
            centerY: centerYAnchor,
            left: leftAnchor,
            paddingLeft: 10,
            widthConst: 70,
            heightConst: 70
        )
        userProfileImageView.layoutIfNeeded()
        userProfileImageView.layer.cornerRadius = userProfileImageView.width / 2
        
        addSubview(userNameLabel)
        userNameLabel.anchors(
            top: topAnchor,
            paddingTop: 5,
            left: userProfileImageView.rightAnchor,
            paddingLeft: 20,
            right: rightAnchor
        )
        
        addSubview(lastMessageLabel)
        lastMessageLabel.anchors(
            top: userNameLabel.bottomAnchor,
            paddingTop: 8,
            left: userProfileImageView.rightAnchor,
            paddingLeft: 20,
            right: rightAnchor,
            paddingRight: 40
        )
    }
    
    public func configure(with model: Conversation) {
        userNameLabel.text = model.recipient_name
        lastMessageLabel.text = model.latest_message.last_message
        if let url = model.recipient_image {
            userProfileImageView.sd_setImage(with: URL(string: url))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
