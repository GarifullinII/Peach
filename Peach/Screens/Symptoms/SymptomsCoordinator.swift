//
//  SymptomsCoordinator.swift
//  Peach
//
//  Created by Василий on 22.09.2023.
//

import Foundation
import Combine

final class SymptomsCoordinator: BaseCoordinator {

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

    func startWith(date: Date) {
        showSymptoms(date: date)
    }

    private func showSymptoms(date: Date) {
        let viewModel = SymptomsViewModelImpl(date: date)
        let view = SymptomsView(viewModel: viewModel)
        let vc = SympotmsViewController(contentView: view)

        viewModel.output.sink { [weak self] output in
            switch output {
                        case .dismiss:
                            self?.output.send(.dismiss)
                        case .clearTextField:
                            break
                        }
        }.store(in: &cancellables)

        router.push(vc, hideBottomBar: true)
    }
}
