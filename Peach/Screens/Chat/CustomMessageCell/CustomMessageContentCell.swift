//
//  CustomMessageContentCell.swift
//  Peach
//
//  Created by Василий on 16.10.2023.
//

import MessageKit
import UIKit

class CustomMessageContentCell: MessageCollectionViewCell {

    // MARK: - Properties

    /// The `MessageCellDelegate` for the cell.
    weak var delegate: MessageCellDelegate?

    /// The container used for styling and holding the message's content view.
    var messageContainerView: UIView = {
        let containerView = UIView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        return containerView
    }()

    /// The top label of the cell.
    var cellTopLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    var cellDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 11)
        return label
    }()

    // MARK: - Custom properties

    // персональный ассистент
    var senderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 11)
        label.textColor = .textGray
        return label
    }()

    // аватар
    var avatarImage: UIImageView = {
        let image = UIImageView(image: AssetImage.avatar.image)
        return image
    }()

    // отметка прочитанного сообщения
    var messageReadedImage: UIImageView = {
        let image = UIImageView(image: AssetImage.message_readed_icon.image)
        return image
    }()

    private lazy var timeStackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            cellDateLabel, messageReadedImage
        ],
        axis: .horizontal,
        distribution: .equalSpacing,
        spacing: 3
    )

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        fatalError()
    }

    // MARK: - Instance methods

    override func prepareForReuse() {
        super.prepareForReuse()

        cellTopLabel.text = nil
        cellTopLabel.attributedText = nil
        cellDateLabel.text = nil
        cellDateLabel.attributedText = nil
        senderLabel.text = nil
        senderLabel.attributedText = nil
    }

    func setupSubviews() {
        messageContainerView.layer.cornerRadius = 10

        contentView.addSubview(messageContainerView)
        contentView.addSubview(avatarImage)
        messageContainerView.addSubview(cellTopLabel)
        messageContainerView.addSubview(timeStackView)
        messageContainerView.addSubview(senderLabel)
    }

    func configure(
        with message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView,
        dataSource: MessagesDataSource,
        and sizeCalculator: BaseLayoutCalculator
    ) {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }

        avatarImage.frame = sizeCalculator.cellAvatarFrame(for: message, at: indexPath)
        senderLabel.text = message.sender.senderId == SenderID.senderAPI.rawValue ?
        AssetString.personal_assistant.text : AssetString.me.text

        senderLabel.frame = sizeCalculator.cellSenderLabelFrame(
            for: message,
            at: indexPath)

        timeStackView.subviews[1].isHidden = message.sender.senderId == SenderID.senderAPI.rawValue
        timeStackView.frame = sizeCalculator.cellTimeStackViewFrame(
            for: message,
            at: indexPath)

        messageContainerView.frame = sizeCalculator.messageContainerFrame(
            for: message,
            at: indexPath,
            fromCurrentSender: dataSource
                .isFromCurrentSender(message: message))
        cellDateLabel.attributedText = dataSource.messageBottomLabelAttributedText(
            for: message,
            at: indexPath)
        messageContainerView.backgroundColor = displayDelegate.backgroundColor(
            for: message,
            at: indexPath,
            in: messagesCollectionView)
    }
}
