//
//  ProfileCoordinator.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit
import Combine
import BottomSheet

final class ProfileCoordinator: BaseCoordinator {

    // MARK: - Nested types

    enum Output {
        case dismiss
    }

    // MARK: - Properties

    var output = PassthroughSubject<Output, Never>()

    private var cancellables = Set<AnyCancellable>()

    private let router: Router

    // MARK: - Initializers

    init(router: Router) {
        self.router = router
    }

    deinit {
        print("❌Deinit \(String(describing: self))")
    }

    // MARK: - Instance methods

    override func start() {
        showProfile()
    }

    private func showProfile() {
        let viewModel = ProfileViewModelImpl()
        let view = ProfileView(viewModel: viewModel)
        let vc = ProfileViewController(contentView: view)

        viewModel.output.sink { [weak self] output in
            guard let self else { return }

            switch output {
            case .showPremium:
                self.showPremiumBy(type: .sheet(.medium))
            case .showAssiatant:
                self.showPremiumBy(type: .big)
            case .showHealthReport:
                self.showUnderDevelopment()
            case .goToSetNameAndAge:
                self.showSignIn()
            }
        }.store(in: &cancellables)

        router.setRootModule(vc)
    }
}

extension ProfileCoordinator {

    // MARK: - Instance methods

    private func showUnderDevelopment() {
        let vc = UnderDevelopmentViewController()
        router.push(vc)
    }

    private func showPremiumBy(type: PresentationType) {
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

    private func showSignIn() {
        self.childCoordinators.forEach {
            removeDependency($0)
        }
        self.output.send(.dismiss)
    }
}
