//
//  ChatCoordinator.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit
import Combine

final class ChatCoordinator: BaseCoordinator {

    // MARK: - Nested types

    enum Output {
        case dismiss
    }

    // MARK: - Properties

    lazy var output = PassthroughSubject<Output, Never>()

    private var cancellables = Set<AnyCancellable>()

    private let router: Router

    private let tabBarRouter: TabBarRouter

    // MARK: - Initializers

    init(router: Router, tabBarRouter: TabBarRouter) {
        self.router = router
        self.tabBarRouter = tabBarRouter
    }

    deinit {
        print("❌Deinit \(String(describing: self))")
    }

    // MARK: - Instance methods

    override func start() {
        showChat()
    }

    private func showChat() {
        let viewModel = ChatViewModelImpl()
        let chatViewController = ChatViewController(viewModel: viewModel)

        viewModel.output.sink { [weak self] event in
            guard let self else { return }

            switch event {
            case .back:
                self.router.popModule()
                self.tabBarRouter.changeRoot(to: 0)
            case .showPro(let type):

                switch type {
                case .big:
                    self.showPremium(type: .big)
                case .sheet:
                    self.showPremium(type: .sheet(.small))
                }
            default:
                break
            }
        }.store(in: &cancellables)

        router.setRootModule(chatViewController)
    }
}

extension ChatCoordinator {

    // MARK: - Instance methods

    private func showPremium(type: PresentationType) {
        let coordinator = PremiumCoordinator(router: router, presentationType: type)
        addDependency(coordinator)

        coordinator.output
            .sink { [weak self, weak coordinator] output in
                guard let self else { return }

                switch output {
                case .dismiss:
                    self.removeDependency(coordinator)
                    self.router.popModule()
                }
            }.store(in: &cancellables)

        coordinator.start()
    }
}
