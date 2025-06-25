//
//  CalendarCoordinator.swift
//  Peach
//
//  Created by Василий on 30.10.2023.
//

import UIKit
import Combine
import SwiftUI

final class CalendarSwiftUICoordinator: BaseCoordinator {

    // MARK: - Properties

    private let router: Router

    private var cnacellables = Set<AnyCancellable>()

    // MARK: - Initializers

    init(router: Router) {
        self.router = router
    }

    deinit {
        print("❌Deinit \(String(describing: self))")
    }

    // MARK: - Instance methods

    override func start() {
        showCalendar()
    }

    private func showCalendar() {
        let viewModel = CalendarViewModelSwiftUI()

        viewModel.buttonDidTap = { [weak self] in
            self?.showSymptoms()
        }

        let vc = UIHostingController(
            rootView: CalendarContentView()
                .environmentObject(viewModel)
        )
        vc.navigationController?.isNavigationBarHidden = true
        router.setRootModule(vc)
    }

    private func showSymptoms() {
        let coordinator = SymptomsCoordinator(router: router)
        addDependency(coordinator)

        coordinator.output
            .sink { [weak self, weak coordinator] output in
            guard let self else { return }

            switch output {
            case .dismiss:
                self.removeDependency(coordinator)
                self.router.popModule()
            }
        }.store(in: &cnacellables)

        coordinator.start()
    }
}
