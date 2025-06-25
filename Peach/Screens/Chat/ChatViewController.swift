//
//  ChatViewController.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Combine
import SnapKit

final class ChatViewController: BaseChatController {

    // MARK: - Properties

    lazy var limitOverView = LimitOverView(viewModel: LimitOverViewModel(input: viewModel.input))

    private var cancellables = Set<AnyCancellable>()

    private let viewModel: ChatViewModel

    // MARK: - Initializers

    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()

        setupInputBar()
        setupBars()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
        bind()

        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
        }
    }

    deinit {
        print("❌Deinit \(String(describing: self))")
    }

    // MARK: - Instance methods

    @objc
    private func backButtonAction() {
        viewModel.input.send(.backTap)
    }

    @objc
    private func proButtonAction() {
        viewModel.input.send(.proTap(.big))
    }

    private func bind() {
        viewModel.output.sink { [weak self] output in
            switch output {
            case .answerRecieved(let answer):
                let answwer = Message(
                    sender: SenderList.senderAPI,
                    messageId: UUID().uuidString,
                    sentDate: Date(),
                    kind: .text(answer)
                )
                self?.insertMessage(answwer)
                DispatchQueue.main.async {
                    self?.setTypingIndicatorViewHidden(true, animated: true)
                }
            case .limitIsOver:
                self?.showView()
            default:
                break
            }
        }.store(in: &cancellables)
    }


    private func setupInputBar() {
        messageInputBar = MessageInputBar()
        messageInputBar.delegate = self
        inputBarType = .custom(messageInputBar)
    }

    private func subscribeDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

    private func processInputBar(_ inputBar: InputBarAccessoryView) {
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        inputBar.inputTextView.resignFirstResponder()
        insertMessages(components)
    }

    private func insertMessages(_ data: [Any]) {
        self.setTypingIndicatorViewHidden(false, animated: true)
        for component in data {
            if let questionString = component as? String {
                let question = Message(
                    sender: SenderList.senderUser,
                    messageId: UUID().uuidString,
                    sentDate: Date(),
                    kind: .text(questionString)
                )
                insertMessage(question)
                viewModel.input.send(.answerRequest(questionString))
            }
        }
    }

    private func insertMessage(_ message: Message) {
        viewModel.messagesDataSource.value.append(message)
        // Reload last section to update header/footer labels and insert a new one
        DispatchQueue.main.async {
            self.messagesCollectionView.performBatchUpdates({ [weak self] in
                self?.messagesCollectionView.insertSections(
                    [(self?.viewModel.messagesDataSource.value.count ?? 0) - 1]
                )
                if self?.viewModel.messagesDataSource.value.count ?? 0 >= 2 {
                    self?.messagesCollectionView.reloadSections(
                        [(self?.viewModel.messagesDataSource.value.count ?? 0) - 2]
                    )
                }
            }, completion: { [weak self] _ in
                if self?.isLastSectionVisible() == true {
                    self?.messagesCollectionView.scrollToLastItem(animated: true)
                }
            })
        }
    }

    private func isLastSectionVisible() -> Bool {
        guard !viewModel.messagesDataSource.value.isEmpty else { return false }

        let lastIndexPath = IndexPath(item: 0, section: viewModel.messagesDataSource.value.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }

    private func showView() {
        DispatchQueue.main.async {
            self.view.addSubview(self.limitOverView)
            self.limitOverView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            }
            self.messageInputBar.isHidden = true
            self.messagesCollectionView.contentInset = UIEdgeInsets(
                top: 0, left: 0, bottom: 165, right: 0
            )
        }
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {

    // MARK: - InputBarAccessoryViewDelegate methods

    @objc
    func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: String) {
        processInputBar(messageInputBar)
    }
}

extension ChatViewController: MessagesDataSource {

    // MARK: - MessagesDataSource methods

    func numberOfSections(in _: MessagesCollectionView) -> Int {
        viewModel.messagesDataSource.value.count
    }

    func messageForItem(at indexPath: IndexPath, in _: MessagesCollectionView) -> MessageType {
        viewModel.messagesDataSource.value[indexPath.section]
    }

    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)
            ])
    }

    func messageBottomLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath
    ) -> NSAttributedString? {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let dateString = formatter.string(from: message.sentDate)

        switch message.sender.senderId {
        case SenderID.senderAPI.rawValue:
            return NSAttributedString(
                string: dateString,
                attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2),
                    NSAttributedString.Key.foregroundColor: UIColor.textGray
                ]
            )
        case SenderID.senderUser.rawValue:
            return NSAttributedString(
                string: dateString,
                attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2),
                    NSAttributedString.Key.foregroundColor: UIColor.mainPink
                ]
            )
        default:
            return nil
        }
    }

    func textCell(
      for message: MessageType,
      at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView
    ) -> UICollectionViewCell? {
      let cell = messagesCollectionView.dequeueReusableCell(
        CustomMessageCell.self,
        for: indexPath)
      cell.configure(
        with: message,
        at: indexPath,
        in: messagesCollectionView,
        dataSource: self,
        and: textMessageSizeCalculator
      )
      return cell
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    
    // MARK: - MessagesDisplayDelegate methods
    
    func textColor(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> UIColor {
            return .black
        }
    
    func backgroundColor(
        for message: MessageType,
        at _: IndexPath,
        in _: MessagesCollectionView
    ) -> UIColor {
        isFromCurrentSender(message: message) ? .blueBackground : .tabBarGray
    }
}

extension ChatViewController {

    // MARK: - Instance methods

    private func setupBars() {
        let appearance = UINavigationBarAppearance()
        UINavigationBar.appearance().standardAppearance = appearance

        title = AssetString.assistant.text
        let backButton = UIButton()
        backButton.setImage(AssetImage.backArrow.image, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        let backItem = UIBarButtonItem()
        backItem.customView = backButton

        let proButton = UIButton()
        proButton.setImage(AssetImage.pro.image, for: .normal)
        proButton.addTarget(self, action: #selector(proButtonAction), for: .touchUpInside)
        let proItem = UIBarButtonItem()
        proItem.customView = proButton

//        navigationItem.leftBarButtonItems = [backItem]
        navigationItem.rightBarButtonItems = [proItem]
    }
}
