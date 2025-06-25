//
//  OnboardingCoordinator.swift
//  Peach
//
//  Created by Василий on 13.09.2023.
//

import Foundation
import Combine

final class OnboardingCoordinator: BaseCoordinator {

    // MARK: - Nested types

    enum Output {
        case dismiss
    }

    // MARK: - Properties

    var output = PassthroughSubject<Output, Never>()

    private let router: Router
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializers

    init(router: Router) {
        self.router = router
    }

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    override func start() {
        showOnboarding()
    }

    private func showOnboarding() {
        let viewModel = OnboardingViewModelImpl()
        let view = OnboardingView(viewModel: viewModel)
        let vc = OnboardingViewController(contentView: view)

        viewModel.output.sink { [weak self] output in
            guard let self else { return }

            switch output {
            case .showSignIn:
                self.showSignIn()
            case .dismiss:
                self.output.send(.dismiss)
            }
        }.store(in: &cancellables)

        router.setRootModule(vc)
    }
}

extension OnboardingCoordinator {

    // MARK: - Instance methods

    private func showSignIn() {
        let coordinator = SignInCoordinator(router: router)
        coordinator.addDependency(coordinator)

        coordinator.output.sink { [weak self] output in
            switch output {
            case .dismiss:
                self?.output.send(.dismiss)
                self?.removeDependency(coordinator)
            }
        }.store(in: &cancellables)

        coordinator.start()
    }
}
