//
//  OnboardingCell.swift
//  Peach
//
//  Created by Василий on 13.09.2023.
//

import UIKit
import SnapKit

final class OnboardingCell: BaseCollectionCell {

    // MARK: - Properties

    var continueHandler: ((Int) -> Void)?

    var index: Int?

    private let onboardingImage = UIImageView()

    private let topLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 28, weight: .bold)
    }

    private let bottomLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.numberOfLines = 0
    }

    private let continueButton = PinkButton(state: .goContinue)

    private let indicatorImage = UIImageView()

    // MARK: - Instance methods

    @objc
    private func continueAction() {
        if let index = index {
            continueHandler?(index)
        }
    }

    func configure(model: OnboardingCellModel) {
        onboardingImage.image = model.image
        topLabel.text = model.firstTitle
        bottomLabel.text = model.secondTitle
        indicatorImage.image = model.pageImage
    }

    override func setup() {
        super.setup()

        setTarget()

        add {
            onboardingImage
            topLabel
            bottomLabel
            continueButton
            indicatorImage
        }

        onboardingImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.centerX.equalToSuperview()
        }

        topLabel.snp.makeConstraints { make in
            make.top.equalTo(onboardingImage.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }

        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }

        continueButton.snp.makeConstraints { make in
            make.top.equalTo(bottomLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(54)
            make.width.equalTo(140)
        }

        indicatorImage.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }

    private func setTarget() {
        continueButton.addTarget(
            self,
            action: #selector(continueAction),
            for: .touchUpInside
        )
    }
}
