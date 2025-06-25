//
//  BaseLayoutCalculator.swift
//  Peach
//
//  Created by Василий on 16.10.2023.
//

import MessageKit
import UIKit

class BaseLayoutCalculator: CellSizeCalculator {

    // MARK: - Properties

    var cellTopLabelVerticalPadding: CGFloat = 32
    var cellTopLabelHorizontalPadding: CGFloat = 32
    var cellMessageContainerHorizontalPadding: CGFloat = 24
    var cellMessageContainerExtraSpacing: CGFloat = 16
    var cellMessageContentVerticalPadding: CGFloat = 16
    var cellMessageContentHorizontalPadding: CGFloat = 16
    var cellDateLabelHorizontalPadding: CGFloat = 24
    var cellDateLabelBottomPadding: CGFloat = 8

    var messagesLayout: MessagesCollectionViewFlowLayout {
        layout as! MessagesCollectionViewFlowLayout
    }

    var messageContainerMaxWidth: CGFloat {
        messagesLayout.itemWidth -
        cellMessageContainerHorizontalPadding -
        cellMessageContainerExtraSpacing
    }

    var messagesDataSource: MessagesDataSource {
        self.messagesLayout.messagesDataSource
    }

    // MARK: - Initializer

    init(layout: MessagesCollectionViewFlowLayout? = nil) {
        super.init()

        self.layout = layout
    }

    // MARK: - Instance methods

    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let dataSource = messagesDataSource
        let message = dataSource.messageForItem(
            at: indexPath,
            in: messagesLayout.messagesCollectionView)
        let itemHeight = cellContentHeight(
            for: message,
            at: indexPath)
        return CGSize(
            width: messagesLayout.itemWidth,
            height: itemHeight)
    }

    func cellContentHeight(
        for message: MessageType,
        at indexPath: IndexPath)
    -> CGFloat {
        cellTopLabelSize(
            for: message,
            at: indexPath).height +
//        cellMessageBottomLabelSize(
//            for: message,
//            at: indexPath).height +
        messageContainerSize(
            for: message,
            at: indexPath).height + 20
    }

    // MARK: - Top cell Label

    func cellTopLabelSize(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> CGSize {
        guard let attributedText = messagesDataSource.cellTopLabelAttributedText(
                for: message,
                at: indexPath) else { return .zero }

        let maxWidth = messagesLayout.itemWidth - cellTopLabelHorizontalPadding
        let size = attributedText.size(consideringWidth: maxWidth)
        let height = size.height + cellTopLabelVerticalPadding

        return CGSize(
            width: maxWidth,
            height: height)
    }

    func cellTopLabelFrame(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> CGRect {
        let size = cellTopLabelSize(
            for: message,
            at: indexPath)
        guard size != .zero else {
            return .zero
        }

        let origin = CGPoint(
            x: cellTopLabelHorizontalPadding / 2,
            y: 0)

        return CGRect(
            origin: origin,
            size: size)
    }

    func cellMessageBottomLabelSize(
        for message: MessageType,
        at indexPath: IndexPath) -> CGSize {
        guard let attributedText = messagesDataSource.messageBottomLabelAttributedText(
                for: message,
                at: indexPath) else { return .zero }
        let maxWidth = messageContainerMaxWidth - cellDateLabelHorizontalPadding

        return attributedText.size(consideringWidth: maxWidth)
    }

    func cellMessageBottomLabelFrame(
        for message: MessageType,
        at indexPath: IndexPath) -> CGRect {
        let messageContainerSize = messageContainerSize(
            for: message,
            at: indexPath)
        let labelSize = cellMessageBottomLabelSize(
            for: message,
            at: indexPath)
        let x = messageContainerSize.width - labelSize.width - (cellDateLabelHorizontalPadding / 2)
        let y = messageContainerSize.height - labelSize.height - cellDateLabelBottomPadding
        let origin = CGPoint(
            x: x,
            y: y)

        return CGRect(origin: origin, size: labelSize)
    }

    // date stack view
    func cellTimeStackViewSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        guard let attributedText = messagesDataSource.messageBottomLabelAttributedText(
                for: message,
                at: indexPath) else { return .zero }

        let attributedTextWidth = attributedText.size(consideringWidth: 100).width + 19
        let attributedTextHeight = attributedText.size(consideringWidth: 100).height

        return CGSize(width: attributedTextWidth, height: attributedTextHeight)
    }

    func cellTimeStackViewFrame(for message: MessageType, at indexPath: IndexPath) -> CGRect {
        let messageContainerSize = messageContainerSize(
            for: message,
            at: indexPath)
        let labelSize = cellTimeStackViewSize(
            for: message,
            at: indexPath)
        let x = messageContainerSize.width - labelSize.width - (cellDateLabelHorizontalPadding / 2)
        let y = messageContainerSize.height - labelSize.height - cellDateLabelBottomPadding
        let origin = CGPoint(x: x, y: y)

        return CGRect(origin: origin, size: labelSize)
    }

    // sender label
    func cellSenderLabelSize(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> CGSize {
        let textAtributes = NSAttributedString(string: AssetString.personal_assistant.text)

        return textAtributes.size(consideringWidth: 400)
    }

    func cellSenderLabelFrame(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> CGRect {
        let size = cellSenderLabelSize(for: message, at: indexPath)
        let origin = CGPoint(x: 8 , y: 16)

        return CGRect(origin: origin, size: size)
    }

    // avatar
    func cellAvatarSize() -> CGSize {
        return CGSize(width: 48, height: 48)
    }

    func cellAvatarFrame(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> CGRect {
        let messageContainerSize = messageContainerSize(for: message, at: indexPath)
        let avatarSize = cellAvatarSize()

        let x: CGFloat = 0
        let y: CGFloat = messageContainerSize.height - cellAvatarSize().height
        let origin = CGPoint(x: x, y: y)

        return message.sender.senderId == SenderID.senderUser.rawValue
        ? CGRect.zero : CGRect(origin: origin, size: avatarSize)
    }

    // MARK: - MessageContainer (контейнер всей ячейки)

    func messageContainerSize(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> CGSize {
        let labelSize = cellMessageBottomLabelSize(
            for: message,
            at: indexPath)
        let width = labelSize.width +
        cellMessageContentHorizontalPadding +
        cellDateLabelHorizontalPadding

        let height = labelSize.height +
        cellMessageContentVerticalPadding +
        cellDateLabelBottomPadding + 8 +
        cellSenderLabelSize(for: message, at: indexPath).height

        return CGSize(width: width, height: height)
    }

    func messageContainerFrame(
        for message: MessageType,
        at indexPath: IndexPath,
        fromCurrentSender: Bool
    ) -> CGRect {
        let y = cellTopLabelSize(
            for: message,
            at: indexPath).height
        let size = messageContainerSize(
            for: message,
            at: indexPath)
        let origin: CGPoint
        if fromCurrentSender {
            let x = messagesLayout.itemWidth -
            size.width -
            (cellMessageContainerHorizontalPadding / 2)
            origin = CGPoint(x: x, y: y)
        } else {
            origin = CGPoint(
                x: cellMessageContainerHorizontalPadding / 2 + 45, y: y)
        }

        return CGRect(origin: origin, size: size)
    }
}

