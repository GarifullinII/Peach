//
//  ExpandedView.swift
//  Peach
//
//  Created by Василий on 09.10.2023.
//

import UIKit
import Combine
import SnapKit

final class ExpandedView: UIView {

    // MARK: - Properties

    let viewModel: ExpandedViewModel

    private let closeButton = UIButton().then {
        $0.setImage(AssetImage.close_button_icon.image, for: .normal)
    }

    private let dayStatusImage = UIImageView(image: AssetImage.calendar_purple_frame.image)

    private let symptomsButton = UIButton().then {
        $0.configuration = .borderless()
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.mainPink.cgColor
        $0.setTitle(AssetString.mark_symptoms.text, for: .normal)
        $0.setTitleColor(.mainPink, for: .normal)
        $0.setImage(AssetImage.add_symptoms_small.image, for: .normal)
    }

    // MARK: - Initializers

    init(viewModel: ExpandedViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        setup()
        setupTargets()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    deinit {
        print("❌Deinit \(String(describing: self))")
    }

    // MARK: - Instance methods

    @objc
    private func changeAppearenceAction() {
        viewModel.input.send(.changeHeight)
    }

    @objc
    private func decreaseViewHeightAction() {
        viewModel.input.send(.decreaseHeight)
    }

    @objc
    private func showSymptomsAction() {
        viewModel.input.send(.showSymptoms)
    }

    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = 16.0
        isUserInteractionEnabled = true

        dropShadow()
        setupSubviews()
    }

    private func setupSubviews() {
        add {
            closeButton
            dayStatusImage
            symptomsButton
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }

        dayStatusImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }

        symptomsButton.snp.makeConstraints { make in
            make.top.equalTo(dayStatusImage.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }

    private func setupTargets() {
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(changeAppearenceAction)
            )
        )
        closeButton.addTarget(
            self,
            action: #selector(decreaseViewHeightAction),
            for: .touchUpInside
        )
        symptomsButton.addTarget(
            self,
            action: #selector(showSymptomsAction),
            for: .touchUpInside
        )
    }
}
