//
//  PinkButton.swift
//  Peach
//
//  Created by Василий on 12.09.2023.
//

import UIKit

final class PinkButton: UIButton {

    // MARK: - Nested types

    enum State {
        case checkout
        case askQuestion
        case save
        case changeDate
        case goContinue

        var title: String {
            switch self {
            case .checkout:
                return AssetString.checkOut.text
            case .askQuestion:
                return AssetString.askQuestion.text
            case .save:
                return AssetString.save.text
            case .changeDate:
                return AssetString.changeDate.text
            case .goContinue:
                return AssetString.goContinue.text
            }
        }
    }

    // MARK: - Initializers

    init(state: State) {
        super.init(frame: .zero)

        setTitle(state.title, for: .normal)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance methods

    private func setup() {
        layer.cornerRadius = 16.0
        backgroundColor = .mainPink
        setTitleColor(.white, for: .normal)
    }
}
