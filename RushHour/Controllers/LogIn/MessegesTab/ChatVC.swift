//
//  ChatVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 19.11.2021.
//

import UIKit
import MessageKit

class ChatVC: MessagesViewController {

    private var messages = [Message]()
    
    private let selfSender = Sender(photo: "",
                                   senderId: "1",
                                   displayName: "Шакиров Артем")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let messageText = "Привет! Как дела?"
        
        messages.append(Message(sender: selfSender,
                               messageId: "1",
                               sentDate: Date(),
                                kind: .text(messageText)))

        view.backgroundColor = .systemGray6
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
    }

}

extension ChatVC: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
    
}
