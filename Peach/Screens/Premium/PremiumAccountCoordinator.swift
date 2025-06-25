//
//  PremiumCoordinator.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit
import Combine
import BottomSheet

final class PremiumCoordinator: BaseCoordinator {

    // MARK: - Nested types

    enum Output {
        case dismiss
    }

    // MARK: - Properties

    lazy var output = PassthroughSubject<Output, Never>()

    private var cancellables = Set<AnyCancellable>()

    private var router: Router

    private let presentationType: PresentationType

    // MARK: - Initializers

    init(router: Router, presentationType: PresentationType) {
        self.router = router
        self.presentationType = presentationType
    }

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    override func start() {
        showPremium()
    }

    private func showPremium() {
        let viewModel = PremiumAccountViewModelImpl(presentation: presentationType)
        let premiumView = PremiumAccountView(viewModel: viewModel)
        let sheetView = PremiumAccountSheetView(viewModel: viewModel)

        viewModel.output.sink { [weak self] event in
            guard let self else { return }

            switch event {
            case .showPayment(let id):
                print("Show payment by \(id)")
            case .dismsiss:
                self.output.send(.dismiss)
                self.router.popModule()
            }
        }.store(in: &cancellables)

        if presentationType == .large {
            let viewController = PremiumAccountViewController(contentView: premiumView)
            router.push(viewController)
        } else {
            let viewController = ResizeViewController(initialHeight: 300)
            router.presentSheet(viewController)
        }
    }
}
