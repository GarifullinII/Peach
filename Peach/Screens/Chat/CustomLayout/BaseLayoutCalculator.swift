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
        //        messagesLayout.itemWidth -
        
        let itemWidth = messagesLayout.itemWidth
        
        // Проверяем валидность itemWidth
        guard itemWidth.isFinite && !itemWidth.isNaN && itemWidth > 0 else {
            print("⚠️ Warning: Invalid itemWidth in messageContainerMaxWidth: \(itemWidth)")
            return 200 // Возвращаем безопасное значение по умолчанию
        }
        
        let maxWidth = itemWidth - cellMessageContainerHorizontalPadding -
        cellMessageContainerExtraSpacing
        
        // Проверяем валидность вычисленного maxWidth
        guard maxWidth.isFinite && !maxWidth.isNaN && maxWidth > 0 else {
            print("⚠️ Warning: Invalid calculated messageContainerMaxWidth: \(maxWidth) (itemWidth: \(itemWidth))")
            return 200
        }
        
        return maxWidth
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
        
        // Проверяем валидность maxWidth
        guard maxWidth > 0, maxWidth.isFinite, !maxWidth.isNaN else {
            print("⚠️ Warning: Invalid maxWidth in cellTopLabelSize: \(maxWidth)")
            return CGSize.zero
        }
        
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
            
            // Проверяем валидность maxWidth
            guard maxWidth > 0, maxWidth.isFinite, !maxWidth.isNaN else {
                print("⚠️ Warning: Invalid maxWidth in cellMessageBottomLabelSize: \(maxWidth)")
                return CGSize.zero
            }
            
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
            
            // Проверяем валидность размеров контейнера
            guard messageContainerSize.width.isFinite && !messageContainerSize.width.isNaN &&
                    messageContainerSize.height.isFinite && !messageContainerSize.height.isNaN &&
                    labelSize.width.isFinite && !labelSize.width.isNaN &&
                    labelSize.height.isFinite && !labelSize.height.isNaN else {
                print("⚠️ Warning: Invalid sizes in cellMessageBottomLabelFrame - container: \(messageContainerSize), label: \(labelSize)")
                return CGRect(x: 0, y: 0, width: 100, height: 20)
            }
            
            let x = messageContainerSize.width - labelSize.width - (cellDateLabelHorizontalPadding / 2)
            let y = messageContainerSize.height - labelSize.height - cellDateLabelBottomPadding
            //            let origin = CGPoint(
            //                x: x,
            //                y: y)
            
            // Проверяем валидность вычисленных координат
            guard x.isFinite && !x.isNaN && y.isFinite && !y.isNaN else {
                print("⚠️ Warning: Invalid coordinates in cellMessageBottomLabelFrame - x: \(x), y: \(y)")
                return CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height)
            }
            
            let origin = CGPoint(x: x, y: y)
            
            return CGRect(origin: origin, size: labelSize)
        }
    
    // date stack view
    func cellTimeStackViewSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        guard let attributedText = messagesDataSource.messageBottomLabelAttributedText(
            for: message,
            at: indexPath) else { return .zero }
        
        //        let attributedTextWidth = attributedText.size(consideringWidth: 100).width + 19
        //        let attributedTextHeight = attributedText.size(consideringWidth: 100).height
        
        // Проверяем валидность ширины перед использованием
        let maxWidth: CGFloat = 100
        guard maxWidth > 0, maxWidth.isFinite, !maxWidth.isNaN else {
            print("⚠️ Warning: Invalid maxWidth in cellTimeStackViewSize")
            return CGSize(width: 50, height: 20)
        }
        
        let calculatedSize = attributedText.size(consideringWidth: maxWidth)
        let attributedTextWidth = calculatedSize.width + 19
        let attributedTextHeight = calculatedSize.height
        
        return CGSize(width: attributedTextWidth, height: attributedTextHeight)
    }
    
    func cellTimeStackViewFrame(for message: MessageType, at indexPath: IndexPath) -> CGRect {
        let messageContainerSize = messageContainerSize(
            for: message,
            at: indexPath)
        let labelSize = cellTimeStackViewSize(
            for: message,
            at: indexPath)
        
        // Проверяем валидность размеров контейнера
        guard messageContainerSize.width.isFinite && !messageContainerSize.width.isNaN &&
                messageContainerSize.height.isFinite && !messageContainerSize.height.isNaN &&
                labelSize.width.isFinite && !labelSize.width.isNaN &&
                labelSize.height.isFinite && !labelSize.height.isNaN else {
            print("⚠️ Warning: Invalid sizes in cellTimeStackViewFrame - container: \(messageContainerSize), label: \(labelSize)")
            return CGRect(x: 0, y: 0, width: 50, height: 20)
        }
        
        let x = messageContainerSize.width - labelSize.width - (cellDateLabelHorizontalPadding / 2)
        let y = messageContainerSize.height - labelSize.height - cellDateLabelBottomPadding
        
        // Проверяем валидность вычисленных координат
        guard x.isFinite && !x.isNaN && y.isFinite && !y.isNaN else {
            print("⚠️ Warning: Invalid coordinates in cellTimeStackViewFrame - x: \(x), y: \(y)")
            return CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height)
        }
        
        let origin = CGPoint(x: x, y: y)
        
        return CGRect(origin: origin, size: labelSize)
    }
    
    // sender label
    func cellSenderLabelSize(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> CGSize {
        let textAtributes = NSAttributedString(string: AssetString.personal_assistant.text)
        
        //        return textAtributes.size(consideringWidth: 400)
        
        // Проверяем валидность ширины перед использованием
        let maxWidth: CGFloat = 400
        guard maxWidth > 0, maxWidth.isFinite, !maxWidth.isNaN else {
            print("⚠️ Warning: Invalid maxWidth in cellSenderLabelSize")
            return CGSize(width: 100, height: 20)
        }
        
        return textAtributes.size(consideringWidth: maxWidth)
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
        
        let senderLabelSize = cellSenderLabelSize(for: message, at: indexPath)
        
        // Проверяем валидность размеров
        guard labelSize.width.isFinite && !labelSize.width.isNaN &&
                labelSize.height.isFinite && !labelSize.height.isNaN &&
                senderLabelSize.height.isFinite && !senderLabelSize.height.isNaN else {
            print("⚠️ Warning: Invalid sizes in messageContainerSize - label: \(labelSize), sender: \(senderLabelSize)")
            return CGSize(width: 200, height: 100)
        }
        
        let width = labelSize.width +
        cellMessageContentHorizontalPadding +
        cellDateLabelHorizontalPadding
        
        let height = labelSize.height +
        cellMessageContentVerticalPadding +
        cellDateLabelBottomPadding + 8 +
        //        cellSenderLabelSize(for: message, at: indexPath).height
        senderLabelSize.height
        
        // Проверяем валидность вычисленных размеров
        guard width.isFinite && !width.isNaN && width > 0 &&
                height.isFinite && !height.isNaN && height > 0 else {
            print("⚠️ Warning: Invalid calculated size in messageContainerSize - width: \(width), height: \(height)")
            return CGSize(width: 200, height: 100)
        }
        
        return CGSize(width: width, height: height)
    }
    
    func messageContainerFrame(
        for message: MessageType,
        at indexPath: IndexPath,
        fromCurrentSender: Bool
    ) -> CGRect {
        //        let y = cellTopLabelSize(
        let topLabelHeight = cellTopLabelSize(
            for: message,
            at: indexPath).height
        let size = messageContainerSize(
            for: message,
            at: indexPath)
        
        // Проверяем валидность размеров
        guard topLabelHeight.isFinite && !topLabelHeight.isNaN &&
                size.width.isFinite && !size.width.isNaN &&
                size.height.isFinite && !size.height.isNaN &&
                messagesLayout.itemWidth.isFinite && !messagesLayout.itemWidth.isNaN else {
            print("⚠️ Warning: Invalid values in messageContainerFrame - topHeight: \(topLabelHeight), size: \(size), itemWidth: \(messagesLayout.itemWidth)")
            return CGRect(x: 0, y: 0, width: 200, height: 100)
        }
        
        let y = topLabelHeight
        
        let origin: CGPoint
        if fromCurrentSender {
            let x = messagesLayout.itemWidth -
            size.width -
            (cellMessageContainerHorizontalPadding / 2)
            //            origin = CGPoint(x: x, y: y)
            // Проверяем валидность вычисленной координаты x
            if x.isFinite && !x.isNaN {
                origin = CGPoint(x: x, y: y)
            } else {
                print("⚠️ Warning: Invalid x coordinate in messageContainerFrame: \(x)")
                origin = CGPoint(x: 0, y: y)
            }
        } else {
            origin = CGPoint(
                x: cellMessageContainerHorizontalPadding / 2 + 45, y: y)
        }
        
        return CGRect(origin: origin, size: size)
    }
}

