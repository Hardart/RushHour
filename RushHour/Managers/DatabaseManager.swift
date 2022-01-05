//
//  DatabaseManager.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.11.2021.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database(url: "https://chat-app-ios-a7b3a-default-rtdb.europe-west1.firebasedatabase.app").reference()
    
}

//MARK: -Account managment
extension DatabaseManager {
    /// Проверка существования пользователя
    public func doesUserExist(with email: String, completion: @escaping((Bool) -> Void)) {
        
        
        database.child("users").observe(.value, with: { snapshot in
            guard let users = snapshot.value as? NSDictionary else {
                completion(false)
                return
            }
            let collection = try? users.toUserModel()
            collection?.forEach({ (key: String, value: UserFullData) in
                if value.email == email.trimmingCharacters(in: .whitespacesAndNewlines) {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        })
    }
    
    /// Добавление нового пользователя в базу
    public func insertUser(with user: UserFullData, uid: String, completion: @escaping (Bool) -> Void) {
        
        database.child("users").child(uid).setValue(
            try? user.asDictionary(),
            withCompletionBlock: {[weak self] error, _ in
                guard error == nil else {
                    print("withCompletionBlock error")
                    completion(false)
                    return
                }
                
                
                self?.database.child("usersCollection").observeSingleEvent(of: .value, with: {[weak self] snapshot in

                    let newUser = UserShortData(name: user.fullName, uid: uid)
                    if snapshot.exists() {
                        guard let userCollection = snapshot.value as? NSArray else { return }
                        guard var usersArray = try? userCollection.toUsersArray() else { return }
                        usersArray.append(newUser)
                        self?.database.child("usersCollection").setValue(try? usersArray.asArray())
                    } else {
                        self?.database.child("usersCollection").setValue([try? newUser.asDictionary()])
                    }
                })
                completion(true)
            })
    }
    
    /// Поиск всех пользователей
    public func getAllFromUsersCollection(completion: @escaping (Result<[[String:String]], DatabaseErrors>) -> Void) {
        database.child("usersCollection").observeSingleEvent(of: .value, with: { snap in
            guard let value = snap.value as? [[String:String]] else {
                completion(.failure(.failedToFetch))
                return
            }
            
            completion(.success(value))
            
        })
    }
    
    public func getUser(by UID: String, completion: @escaping (UserShortData) -> Void) {
        database.child("usersCollection").observeSingleEvent(of: .value, with: { snap in
            guard let value = snap.value as? NSArray else {
                return
            }
            guard let users = try? value.toUsersArray() else { return }
            for user in users {
                if user.uid == UID {
                    completion(user)
                }
            }
        })

    }
    
}

//MARK: -Messages managnent
extension DatabaseManager {
    
    /// Чат с выбранным пользователем
    public func createNewConversation(with secondUserUID: String, recipientName: String, message: Message, completion: @escaping (Bool) -> Void) {
        
        guard let userData = UserDataCache.shared.getUserData() else { return }
        let selfUID = userData.uid
        
        let conversationUID = UUID().uuidString
        let conversationsPath = database.child("conversations")
        let userPathInDB = database.child("users/\(selfUID)")
        let selfConversationsPath = database.child("users/\(selfUID)/conversations/\(secondUserUID)")
        let recipientConversationsPath = database.child("users/\(secondUserUID)/conversations/\(selfUID)")
        
        var messageText = ""
        switch message.kind {
        case .text(let text):
            messageText = text
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        let profileImageName =  "images/\(secondUserUID)_profile_image.png"
        StorageManager.shared.getDownloadURL(for: profileImageName) { urlString in
            
            userPathInDB.observeSingleEvent(of: .value, with: { snapshot in
                
                guard let userPath = snapshot.value as? NSDictionary else { return }
                guard let selfName = try? userPath.toUser().fullName else {
                    print("toUser false decoding")
                    return
                }
                let imageUrl = userData.imageURL
                
                /// Модель последнего сообщения
                let lastMessage = LastMessage(date: message.sentDate, last_message: messageText, is_read: false)
                /// Модель чата в ноде оправителя сообщения
                let newConversationModelForSelf = Conversation(id: conversationUID, recipient_name: recipientName, recipient_uid: secondUserUID, recipient_image: urlString, latest_message: lastMessage)
                /// Модель чата в ноде получателя сообщения
                let newConversationModelForRecipient = Conversation(id: conversationUID, recipient_name: selfName, recipient_uid: selfUID, recipient_image: imageUrl, latest_message: lastMessage)
                
                let conversationMessage = ConversationMessage(id: message.messageId, type: "", text: messageText, date: Date(), sender_uid: selfUID, is_read: false, sender_name: selfName )
                
                guard let newSelfConversation = try? newConversationModelForSelf.asDictionary(),
                      let newRecipientConversation = try? newConversationModelForRecipient.asDictionary(),
                      let newConversationNode = try? ConversationMessages(messages: [conversationMessage]).asDictionary() else { return }
                
                
                recipientConversationsPath.observeSingleEvent(of: .value, with: { snapshot in
                    /// если чат уже существует у отпраителя ( пока что это значит что и другого пользователя он есть)
                    if snapshot.exists() {
                        /// Обновляем последнее сообщение в нодах у пользователей
                        guard let convo = snapshot.value as? NSDictionary else { return }
                        var conversation = try? convo.toConversationModel()
                        conversation?.latest_message = lastMessage
                        recipientConversationsPath.setValue(try? conversation.asDictionary())
                    }
                })
                
                selfConversationsPath.observeSingleEvent(of: .value, with: { snapshot in
                    /// если чат уже существует у отпраителя ( пока что это значит что и другого пользователя он есть)
                    if snapshot.exists() {
                        /// Обновляем последнее сообщение в нодах у пользователей
                        guard let convo = snapshot.value as? NSDictionary else { return }
                        var conversation = try? convo.toConversationModel()
                        conversation?.latest_message = lastMessage
                        selfConversationsPath.setValue(try? conversation.asDictionary())
                        guard let convoUID = conversation?.id else {
                            print("В корневой ноде Conversations нет UID")
                            return
                        }
                        
                        /// Добавляем сообщение в чат в корневой ноде Conversations
                        conversationsPath.child(convoUID).observeSingleEvent(of: .value, with: {snapshot in
                            guard let result = snapshot.value as? NSDictionary else { return }
                            var messagesCollection = try? result.toConversationMessagesModel()
                            messagesCollection?.messages.append(conversationMessage)
                            let newMessageCollection = try? messagesCollection.asDictionary()
                            conversationsPath.child(convoUID).setValue(newMessageCollection)
                        })
                        
                        completion(true)
                        /// else DONE and WORKING
                    } else {
                        selfConversationsPath.setValue(newSelfConversation)
                        recipientConversationsPath.setValue(newRecipientConversation)
                        /// Сохраняем чат в корневую ноду Conversations
                        conversationsPath.child(conversationUID).setValue(newConversationNode)
                        completion(true)
                    }
                })
                
            })
        }
    }
    
    /// Запрос всех чатов для пользователя
    public func getAllConversations(for userUID: String, completion: @escaping (Result<[Conversation], DatabaseErrors>) -> Void) {
        
        let conversationsPath = database.child("users/\(userUID)/conversations")
        
        conversationsPath.observe(.value, with: {snapshot in
            if !snapshot.exists() {
                completion(.failure(.pathDoesNotExist))
            }
            guard let result = snapshot.value as? NSDictionary else {
                completion(.failure(.failedToFetch))
                return
            }
            
            guard let resultDictionary = try? result.toCollectionModel() else {
                completion(.failure(.failesToDecode))
                return
            }
            var conversations: [Conversation] = []
            resultDictionary.forEach { (key: String, value: Conversation) in
                conversations.append(value)
            }
            
            
            completion(.success(conversations))
            
        })
    }
    
    /// Получаем все сообщения из одного чата
    public func getAllMessagesForConversation(for uid: String, completion: @escaping (Result<[Message], DatabaseErrors>) -> Void) {
        database.child("conversations/\(uid)/messages").observe(.value, with: {snapshot in
            
            guard let result = snapshot.value as? NSArray else {
                completion(.failure(.failedToFetch))
                return
            }
            
            guard let messagesModel = try? result.toMessagesArray() else {
                completion(.failure(.failesToDecode))
                return
            }
            
            let messages: [Message] = messagesModel.compactMap({ message in
                let sender = Sender(photo: "", senderId: message.sender_uid, displayName: message.sender_name)
                return Message(sender: sender, messageId: message.id, sentDate: message.date, kind: .text(message.text))
            })
            
            completion(.success(messages))
            
        })
    }
    
    /// Отправляем сообщение в чат
    public func sendMessage(to conversation: String, message: Message, completion: @escaping (Bool) -> Void) {
        
    }
    
    public func getConversationUID(for userUID: String, with recipientUID: String, completion: @escaping (String) -> Void) {
        let conversationsPath = database.child("users/\(userUID)/conversations/\(recipientUID)")
        var convoUID = "none"
        conversationsPath.observeSingleEvent(of: .value, with: {snapshot in
            if snapshot.exists() {
                guard let result = snapshot.value as? NSDictionary else { return }
                convoUID = try! result.toConversationModel().id
                completion(convoUID)
            }
            
        })
        
    }
    
}
