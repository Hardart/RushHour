//
//  NSArray.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.12.2021.
//

import Foundation

extension NSArray {
    
    
    func toMessagesArray() throws -> [ConversationMessage] {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let messageData = try JSONDecoder().decode([ConversationMessage].self, from: data)
            return messageData
        }
        catch let error {
          throw error
        }
    }
    
    func toUsersArray() throws -> [UserShortData] {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let messageData = try JSONDecoder().decode([UserShortData].self, from: data)
            return messageData
        }
        catch let error {
          throw error
        }
    }
    
    
}
