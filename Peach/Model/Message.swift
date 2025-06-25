//
//  Message.swift
//  Peach
//
//  Created by Василий on 02.10.2023.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}
