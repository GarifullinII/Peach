//
//  LimitOverViewModel.swift
//  Peach
//
//  Created by Василий on 23.10.2023.
//

import Foundation
import Combine

final class LimitOverViewModel: BaseViewModel {

    // MARK: - Properties

    var input: PassthroughSubject<ChatEvents, Never>

    // MARK: - Initializer

    init(input: PassthroughSubject<ChatEvents, Never>) {
        self.input = input
    }
}
