//
//  MessageInputBar.swift
//  Peach
//
//  Created by Василий on 02.10.2023.
//

import UIKit
import InputBarAccessoryView

final class MessageInputBar: InputBarAccessoryView {

    // MARK: - Instance methods

    override func setup() {
        super.setup()

        // custom button
        let button = InputBarSendButton()
        button.setSize(CGSize(width: 36, height: 50), animated: false)
        button.setImage(AssetImage.send_icon.image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 14.0
        button.backgroundColor = .mainPink
        setStackViewItems([button], forStack: .right, animated: true)

        // initial state of right button
        setRightStackViewWidthConstant(to: 0, animated: true)

        // observing text input
        button.onTouchUpInside {
            $0.inputBarAccessoryView?.didSelectSendButton()
        }.onTextViewDidChange { _, textView in
            if !textView.text.isEmpty {
                self.setRightStackViewWidthConstant(to: 50, animated: true)
            } else {
                self.setRightStackViewWidthConstant(to: 0, animated: true)
            }
        }

        // input text view properties
        inputTextView.textColor = .black
        inputTextView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 0)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 0)
        inputTextView.layer.borderColor = UIColor.borderGray.cgColor
        inputTextView.layer.borderWidth = 1.0
        inputTextView.layer.cornerRadius = 16.0
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputTextView.placeholder = AssetString.ask_question.text
    }
}
