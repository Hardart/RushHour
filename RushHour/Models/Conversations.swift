//
//  Conversations.swift
//  RushHour
//
//  Created by Артем Шакиров on 17.12.2021.
//

import Foundation

struct ConversationMessages: Codable {
    var messages: [ConversationMessage]
}

struct ConversationMessage: Codable {
    let id: String
    let type: String
    let text: String
    let date: Date
    let sender_uid: String
    let is_read: Bool
    let sender_name: String
}
