//
//  LayoutCalculator .swift
//  Peach
//
//  Created by Василий on 16.10.2023.
//

import MessageKit
import UIKit

final class LayoutCalculator: BaseLayoutCalculator {

    // MARK: - Properties

    var messageLabelFont = UIFont.preferredFont(forTextStyle: .body)

    var cellMessageContainerRightSpacing: CGFloat = 16

    // MARK: - Instance methods

    override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let size = super.messageContainerSize(
            for: message,
            at: indexPath)
        let labelSize = messageLabelSize(
            for: message,
            at: indexPath)
        let selfWidth = labelSize.width +
        cellMessageContentHorizontalPadding +
        cellMessageContainerRightSpacing - 20
        let width = max(selfWidth, size.width)
        let height = size.height + labelSize.height

        return CGSize(width: width, height: height)
    }

    func messageLabelSize(for message: MessageType, at _: IndexPath) -> CGSize {
        let attributedText: NSAttributedString

        switch message.kind {
        case .text(let text):
            attributedText = NSAttributedString(string: text, attributes: [.font: messageLabelFont])
        default:
            fatalError("messageLabelSize received unhandled MessageDataType: \(message.kind)")
        }

        let maxWidth = messageContainerMaxWidth -
        cellMessageContentHorizontalPadding -
        cellMessageContainerRightSpacing

        if attributedText.size(consideringWidth: maxWidth).width <= 150 {
            let attrHeight = attributedText.size(consideringWidth: maxWidth).height
            return CGSize(width: 150, height: attrHeight)
        } else {
            return attributedText.size(consideringWidth: maxWidth)
        }
    }

    func messageLabelFrame(for message: MessageType, at indexPath: IndexPath) -> CGRect {
        let origin = CGPoint(
            x: cellMessageContentHorizontalPadding / 2,
            y: cellMessageContentVerticalPadding * 2)
        let size = messageLabelSize(
            for: message,
            at: indexPath)

        return CGRect(origin: origin, size: size)
    }
}
