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
        
        // Проверяем валидность размеров
        guard size.width.isFinite && !size.width.isNaN &&
                size.height.isFinite && !size.height.isNaN &&
                labelSize.width.isFinite && !labelSize.width.isNaN &&
                labelSize.height.isFinite && !labelSize.height.isNaN else {
            print("⚠️ Warning: Invalid sizes in LayoutCalculator.messageContainerSize - base: \(size), label: \(labelSize)")
            return CGSize(width: 200, height: 100)
        }
        
        let selfWidth = labelSize.width +
        cellMessageContentHorizontalPadding +
        cellMessageContainerRightSpacing - 20
        let width = max(selfWidth, size.width)
        let height = size.height + labelSize.height
        
        // Проверяем валидность вычисленных размеров
        guard width.isFinite && !width.isNaN && width > 0 &&
                height.isFinite && !height.isNaN && height > 0 else {
            print("⚠️ Warning: Invalid calculated size in LayoutCalculator.messageContainerSize - width: \(width), height: \(height)")
            return CGSize(width: 200, height: 100)
        }
        
        return CGSize(width: width, height: height)
    }
    
    func messageLabelSize(for message: MessageType, at _: IndexPath) -> CGSize {
        let attributedText: NSAttributedString
        
        switch message.kind {
        case .text(let text):
            //            attributedText = NSAttributedString(string: text, attributes: [.font: messageLabelFont])
            // Проверяем, что текст не пустой
            let safeText = text.isEmpty ? " " : text
            attributedText = NSAttributedString(string: safeText, attributes: [.font: messageLabelFont])
        default:
            fatalError("messageLabelSize received unhandled MessageDataType: \(message.kind)")
        }
        
        let maxWidth = messageContainerMaxWidth -
        cellMessageContentHorizontalPadding -
        cellMessageContainerRightSpacing
        
        //        if attributedText.size(consideringWidth: maxWidth).width <= 150 {
        //            let attrHeight = attributedText.size(consideringWidth: maxWidth).height
        //            return CGSize(width: 150, height: attrHeight)
        // Проверяем валидность maxWidth перед использованием
        guard maxWidth > 0, maxWidth.isFinite, !maxWidth.isNaN else {
            print("⚠️ Warning: Invalid maxWidth in messageLabelSize: \(maxWidth)")
            return CGSize(width: 150, height: 20)
        }
        
        let calculatedSize = attributedText.size(consideringWidth: maxWidth)
        
        if calculatedSize.width <= 150 {
            return CGSize(width: 150, height: calculatedSize.height)
        } else {
            //            return attributedText.size(consideringWidth: maxWidth)
            return calculatedSize
        }
    }
    
    func messageLabelFrame(for message: MessageType, at indexPath: IndexPath) -> CGRect {
        //        let origin = CGPoint(
        //            x: cellMessageContentHorizontalPadding / 2,
        //            y: cellMessageContentVerticalPadding * 2)
        let size = messageLabelSize(
            for: message,
            at: indexPath)
        
        // Проверяем валидность размера
        guard size.width.isFinite && !size.width.isNaN &&
                size.height.isFinite && !size.height.isNaN else {
            print("⚠️ Warning: Invalid size in messageLabelFrame: \(size)")
            return CGRect(x: 0, y: 0, width: 150, height: 20)
        }
        
        let x = cellMessageContentHorizontalPadding / 2
        let y = cellMessageContentVerticalPadding * 2
        
        // Проверяем валидность координат
        guard x.isFinite && !x.isNaN && y.isFinite && !y.isNaN else {
            print("⚠️ Warning: Invalid coordinates in messageLabelFrame - x: \(x), y: \(y)")
            return CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        
        let origin = CGPoint(x: x, y: y)
        
        return CGRect(origin: origin, size: size)
    }
}
