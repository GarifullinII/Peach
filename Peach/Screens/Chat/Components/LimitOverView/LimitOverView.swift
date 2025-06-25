//
//  LimitOverView.swift
//  Peach
//
//  Created by Василий on 23.10.2023.
//

import UIKit
import SnapKit

final class LimitOverView: BaseContentView<LimitOverViewModel> {

    // MARK: - Properties

    private let descriptionLabel = UILabel().then {
        $0.text = AssetString.limitQuestionsIsOver.text
        $0.numberOfLines = 0
    }

    private lazy var premiumButton = PinkButton(state: .askQuestion).then {
        $0.addTarget(
            self,
            action: #selector(buttonDidTap),
            for: .touchUpInside
        )
    }

    // MARK: - Lifecycle

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    @objc
    private func buttonDidTap() {
        viewModel.input.send(.proTap(.sheet(.small)))
    }

    override func setUp() {
        super.setUp()

        setup()
    }

    private func setup() {
        backgroundColor = .lightPink
        layer.cornerRadius = 16.0

        add {
            descriptionLabel
            premiumButton
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.left.equalToSuperview().offset(16)
        }

        premiumButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.equalTo(descriptionLabel)
            make.right.equalTo(descriptionLabel)
            make.height.equalTo(38)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
