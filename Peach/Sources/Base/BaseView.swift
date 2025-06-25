//
//  BaseView.swift
//  Peach
//
//  Created by Василий on 07.09.2023.
//

import UIKit
import Combine

class BaseContentView<ViewModel: BaseViewModel>: UIView {

    // MARK: - Instance Properties

    var viewModel: ViewModel
    var cancellableSet = Set<AnyCancellable>()

    // MARK: - Initializers

    init(viewModel: ViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        setUp()

        bind().forEach { cancellable in
            cancellableSet.insert(cancellable)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance Methods

    func setUp() {
        backgroundColor = .white
    }

    func bind() -> [AnyCancellable] {
        []
    }
}

