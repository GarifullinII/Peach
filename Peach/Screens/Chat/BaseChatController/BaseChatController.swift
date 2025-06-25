//
//  BaseChatController.swift
//  Peach
//
//  Created by Василий on 02.10.2023.
//

import InputBarAccessoryView
import MessageKit
import UIKit

enum SenderID: String {
    case senderAPI = "0"
    case senderUser = "1"
}

enum SenderList {
    static let senderAPI = Sender(
        senderId: SenderID.senderAPI.rawValue,
        displayName: AssetString.personal_assistant.text
    )
    static let senderUser = Sender(
        senderId: SenderID.senderUser.rawValue,
        displayName: ""
    )
}

class BaseChatController: MessagesViewController {

    // MARK: - Properties

    var currentSender: SenderType {
        SenderList.senderUser
    }

    lazy var textMessageSizeCalculator = LayoutCalculator(
      layout: self.messagesCollectionView
        .messagesCollectionViewFlowLayout
    )

    let apiAvatar = Avatar(image: AssetImage.apiSender_icon.image)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMessageCollectionView()
    }

    deinit {
        print("❌Deinit \(String(describing: self))")
    }

    // MARK: - Instance methods

    private func configureMessageCollectionView() {
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.register(CustomMessageCell.self)
        messagesCollectionView.showsVerticalScrollIndicator = false

        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnInputBarHeightChanged = true
    }
}

extension BaseChatController: MessagesLayoutDelegate {

    // MARK: - MessagesLayoutDelegate methods

    func textCellSizeCalculator(
        for _: MessageType,
        at _: IndexPath,
        in _: MessagesCollectionView) -> CellSizeCalculator? {
            return textMessageSizeCalculator
        }
}
