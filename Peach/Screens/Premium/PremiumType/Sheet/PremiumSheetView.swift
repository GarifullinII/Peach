//
//  PremiumSheetView.swift
//  Peach
//
//  Created by Василий on 20.09.2023.
//

import UIKit
import SnapKit

final class PremiumSheetView: BaseContentView<PremiumViewModelImpl> {

    // MARK: - Properties

    var paymentButtonHandler: (() -> Void)?

    var closeTapHandler: (() -> Void)?

    let tableView = UITableView().then {
        $0.registerCell(type: PaymentCell.self)
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
    }

    private let selectSubscriptionLabel = UILabel().then {
        $0.text = AssetString.select_subscription.text
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }

    private let paymentButton = PinkButton(state: .checkout)

    private let closeButton = UIButton().then {
        $0.setImage(AssetImage.close_button_icon.image, for: .normal)
    }

    private let pinkView = UIView().then {
        $0.backgroundColor = .lightPink
        $0.layer.cornerRadius = 12.0
    }

    private let peachImage = UIImageView(image: AssetImage.peach.image)

    private let greetingsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.text = AssetString.premiumGreetings.text
    }

    private lazy var stackView = UIStackView(
        alignment: .center,
        arrangedSubviews: [
            pinkView,
            tableView,
            paymentButton
        ],
        axis: .vertical,
        distribution: .fill,
        spacing: 10)

    // MARK: - Lifecycle

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    @objc
    private func paymentButtonAction() {
        paymentButtonHandler?()
    }

    @objc
    private func closeButtonAction() {
        closeTapHandler?()
    }

    func configure(type: SheetType) {
        switch type {
        case .small:
            stackView.subviews[0].isHidden = true
        default:
            break
        }
    }

    override func setUp() {
        super.setUp()
        
        setTarget()

        add {
            selectSubscriptionLabel
            closeButton
            stackView
        }

        pinkView.add {
            peachImage
            greetingsLabel
        }

        selectSubscriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }

        pinkView.snp.makeConstraints { make in
            make.top.equalTo(selectSubscriptionLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }

        peachImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(selectSubscriptionLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(40)
        }

        greetingsLabel.snp.makeConstraints { make in
            make.left.equalTo(peachImage.snp.right).offset(16)
            make.top.equalTo(peachImage)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(pinkView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(170)
        }

        paymentButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(54)
        }
    }

    private func setTarget() {
        paymentButton.addTarget(
            self,
            action: #selector(paymentButtonAction),
            for: .touchUpInside
        )
        closeButton.addTarget(
            self,
            action: #selector(closeButtonAction),
            for: .touchUpInside)
    }
}

extension PremiumSheetView: PremiumViewInput {}
