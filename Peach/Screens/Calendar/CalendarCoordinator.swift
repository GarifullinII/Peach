//
//  CalendarCoordinator.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import Combine
import SwiftUI

final class CalendarCoordinator: BaseCoordinator {

    // MARK: - Properties

    var output = PassthroughSubject<Bool, Never>()

    private let router: Router

    private var cancellables = Set<AnyCancellable>()

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
        let viewModel = CalendarViewModel()

        viewModel.showSymptomsHandler = { [weak self] in
            self?.showSymptoms(date: viewModel.selectedDay?.date ?? Date())
        }

        viewModel.hideTabBarHandler = { [weak self] isHide in
            self?.output.send(isHide)
        }

        let vc = UIHostingController(
            rootView: CalendarContentView()
                .environmentObject(viewModel)
        )
        router.setRootModule(vc)
    }

    private func showSymptoms(date: Date) {
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
        }.store(in: &cancellables)

        coordinator.startWith(date: date)
    }
}
