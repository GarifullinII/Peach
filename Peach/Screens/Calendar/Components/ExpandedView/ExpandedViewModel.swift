//
//  ExpandedViewModel.swift
//  Peach
//
//  Created by Василий on 09.10.2023.
//

import Foundation
import Combine

enum InputExpandedEvent {
    case changeHeight
    case decreaseHeight
    case showSymptoms
}

enum OutputExpandedEvent {
    case updateUI
}

protocol ExpandedViewModel: AnyObject {
    var input: PassthroughSubject<InputExpandedEvent, Never> { get }
}

final class ExpandedViewModelImpl: ExpandedViewModel {

    // MARK: - Properties

    var input = PassthroughSubject<InputExpandedEvent, Never>()
    var isViewIncreased: Bool = false
}
