//
//  ChatVC.swift
//  RushHour
//
//  Created by Артем Шакиров on 19.11.2021.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatVC: MessagesViewController {
    
    //MARK: - Elements
    
    public var otherUserUID: String
    private var convUID: String
    
    private var messageCollection:[Message] = []
    
    private var userDataCache = UserDataCache.shared.getUserData()
    
    private let selfSender: Sender
    
    //MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
    }
    
    init(with userUID: String, and chatUID: String?) {
        self.otherUserUID = userUID
        self.convUID = chatUID ?? "trouble with chatUID"
        self.selfSender = Sender(
            photo: userDataCache?.imageURL ?? "no url",
            senderId: userDataCache?.uid ?? "no UID",
            displayName: ""
        )
        super.init(nibName: nil, bundle: nil)
        messagesObserver(conversationUID: self.convUID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -private methods
    fileprivate func messagesObserver(conversationUID: String) {
       
       DatabaseManager.shared.getAllMessagesForConversation(for: conversationUID, completion: { [weak self] result in
           switch result {
           case .success(let messages):
               DispatchQueue.main.async {
                   self?.messageCollection = messages
                   self?.messagesCollectionView.reloadData()
                   self?.messagesCollectionView.scrollToLastItem()
               }
           case .failure(let error):
               print(error)
               break
           }
       })
   }
    
}

extension ChatVC: InputBarAccessoryViewDelegate {
    
    /// Нажал кнопку Send
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard let recipientName = self.title else { return }
        let sendText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let message = Message(
            sender: selfSender,
            messageId: UUID().uuidString,
            sentDate: Date(),
            kind: .text(sendText)
        )
        
        DatabaseManager.shared.createNewConversation(with: otherUserUID, recipientName: recipientName, message: message, completion: {[weak self] readyToSend in
            
            guard let myUID = self?.userDataCache?.uid,
                let recipientUID = self?.otherUserUID else { print("some guard problems")
                    return }
            if readyToSend {
                inputBar.inputTextView.text = ""
                DatabaseManager.shared.getConversationUID(for: myUID, with: recipientUID, completion: {[weak self] uid in
                    self?.messagesObserver(conversationUID: uid)
                })
                
            } else {
                print("some problems")
            }
        })
        
    }
}

extension ChatVC: MessagesDataSource, MessagesDisplayDelegate, MessagesLayoutDelegate {
    
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageCollection[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messageCollection.count
    }
    
    
}
