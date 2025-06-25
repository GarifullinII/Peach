//
//  ChatEvents.swift
//  Peach
//
//  Created by Василий on 07.09.2023.
//

import Foundation
import MessageKit

// input
enum ChatEvents {
    case swipeLeft
    case backTap
    case proTap(_ type: PresentationType)
    case answerRequest(_ question: String)
}

// output
enum ChatOutput {
    case back
    case showPro(_ type: PresentationType)
    case answerRecieved(_ answer: String)
    case limitIsOver
}
