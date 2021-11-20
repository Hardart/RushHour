//
//  Message.swift
//  RushHour
//
//  Created by Артем Шакиров on 20.11.2021.
//

import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
