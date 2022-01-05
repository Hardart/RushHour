//
//  ChatAppUser.swift
//  RushHour
//
//  Created by Артем Шакиров on 13.12.2021.
//

import Foundation


struct UserFullData: Codable {
    let nick_name: String
    let first_name: String
    let last_name: String
    let email: String
    let conversations: [String: Conversation]?
    var profileImage: String
    var fullName: String {
        first_name + " " + last_name
    }
}

struct Conversation: Codable {
    let id: String
    let recipient_name: String
    let recipient_uid: String
    var latest_message: LastMessage
}

struct LastMessage: Codable {
    let date: Date
    let last_message: String
    let is_read: Bool
}
