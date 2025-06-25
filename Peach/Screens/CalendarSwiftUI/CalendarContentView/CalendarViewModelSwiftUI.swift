//
//  CalendarViewModelSwiftUI.swift
//  Peach
//
//  Created by Василий on 03.11.2023.
//

import Foundation

final class CalendarViewModelSwiftUI: ObservableObject {

    var buttonDidTap: (() -> Void)?

    // MARK: - Instance methods

    func buttonWasPressed() {
        buttonDidTap?()
    }
}
