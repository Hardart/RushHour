//
//  NSDictinory.swift
//  RushHour
//
//  Created by Артем Шакиров on 16.12.2021.
//

import Foundation

extension NSDictionary {
    
    func toUserModel() throws -> [String: UserFullData] {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let messageData = try JSONDecoder().decode([String: UserFullData].self, from: data)
            return messageData
        }
        catch let error {
          throw error
        }
    }
    
    func toUser() throws -> UserFullData {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let messageData = try JSONDecoder().decode(UserFullData.self, from: data)
            return messageData
        }
        catch let error {
          throw error
        }
    }
    
    func toUserData() throws -> UserData {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let messageData = try JSONDecoder().decode(UserData.self, from: data)
            return messageData
        }
        catch let error {
          throw error
        }
    }
    
    func toCollectionModel() throws -> [String: Conversation] {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let messageData = try JSONDecoder().decode([String: Conversation].self, from: data)
            return messageData
        }
        catch let error {
          throw error
        }
    }
    
    func toConversationModel() throws -> Conversation {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let messageData = try JSONDecoder().decode(Conversation.self, from: data)
            return messageData
        }
        catch let error {
          throw error
        }
    }
    
    func toConversationMessagesModel() throws -> ConversationMessages {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let messageData = try JSONDecoder().decode(ConversationMessages.self, from: data)
            return messageData
        }
        catch let error {
          throw error
        }
    }
    
}
