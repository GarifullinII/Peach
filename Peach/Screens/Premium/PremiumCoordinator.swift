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
        let viewModel = PremiumViewModelImpl(presentation: presentationType)

        viewModel.output.sink { [weak self] event in
            guard let self else { return }

            switch event {
            case .showPayment(let id):
                print("Show payment by \(id)")
            case .dismsiss:
                self.output.send(.dismiss)
            }
        }.store(in: &cancellables)

        switch presentationType {
        case .big:
            let premiumView = PremiumView(viewModel: viewModel)
            let viewController = PremiumViewController(contentView: premiumView)
            router.push(viewController, hideBottomBar: true)
        case .sheet(let sheetType):
            let sheetView = PremiumSheetView(viewModel: viewModel)
            switch sheetType {
            case .small:
                let viewController = PremiumSheetViewController(
                    contentView: sheetView,
                    currentHeight: 330,
                    type: .small)
                router.presentSheet(viewController)
            case .medium:
                let viewController = PremiumSheetViewController(
                    contentView: sheetView,
                    currentHeight: 450,
                    type: .medium)
                router.presentSheet(viewController)
            case .none:
                break
            }
        }
    }
}
