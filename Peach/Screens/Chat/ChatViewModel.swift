//
//  ChatViewModel.swift
//  Peach
//
//  Created by Василий on 07.09.2023.
//

import Foundation
import Combine

protocol ChatViewModel: AnyObject {
    var messagesDataSource: CurrentValueSubject<[Message], Never> { get set }
    
    var input: PassthroughSubject<ChatEvents, Never> { get }
    
    var output: PassthroughSubject<ChatOutput, Never> { get }
}

final class ChatViewModelImpl: BaseViewModel, ChatViewModel {
    
    // MARK: - Properties
    
    var messagesDataSource = CurrentValueSubject<[Message], Never>([])
    
    let input = PassthroughSubject<ChatEvents, Never>()
    
    let output = PassthroughSubject<ChatOutput, Never>()
    
    private var answerCounter: Int = 0 {
        didSet {
            if answerCounter == maxFreeQuestionsCount {
                output.send(.limitIsOver)
            }
        }
    }
    
    private let maxFreeQuestionsCount = 10
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        
        bind()
        insertFirstMessage()
    }
    
    deinit {
        print("❌Deinit \(String(describing: self))")
    }
    
    // MARK: - Instance methods
    
    private func bind() {
        input.sink { [weak self] input in
            guard let self else { return }
            
            switch input {
            case .backTap, .swipeLeft:
                self.output.send(.back)
            case .proTap(let type):
                self.output.send(.showPro(type))
            case .answerRequest(let question):
                OpenAIManager.shared.performRequest(input: question) { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success(_):
                        //                        self.answerCounter += 1
                        
                        let answerMock = """
Месячные (или менструации) – это ежемесячные физиологические процессы, характерные для женского пола в репродуктивном возрасте. Этот процесс связан с циклическим изменением гормонального фона и физиологическими изменениями в организме женщины.

В общем случае, месячные представляют собой отторжение слизистой оболочки матки, которая подготовилась к приему оплодотворенной яйцеклетки. Если оплодотворения не произошло, уровень гормонов, таких как эстрогены и прогестерон, снижается, что приводит к отторжению слойки матки. Этот процесс сопровождается кровяным выделением из влагалища, которое и называется месячными.

"""
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.output.send(.answerRecieved(answerMock))
                        }
                        
                    case .failure(let failure):
                        debugPrint(failure)
                    }
                }
            }
        }.store(in: &cancellables)
    }
    
    private func insertFirstMessage() {
        let message = Message(
            sender: SenderList.senderAPI,
            messageId: UUID().uuidString,
            sentDate: Date(),
            kind: .text(AssetString.ask_ten_questions_free.text)
        )
        messagesDataSource.value.append(message)
    }
}
