//
//  PremiumView.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit
import SnapKit

final class PremiumView: BaseContentView<PremiumViewModelImpl> {

    // MARK: - Properties

    var paymentButtonHandler: (() -> Void)?

    var closeTapHandler: (() -> Void)?

    var tableView = UITableView().then {
        $0.registerCell(type: PaymentCell.self)
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
    }

    private let paymentButton = PinkButton(state: .checkout)

    private let pinkView = UIView().then {
        $0.backgroundColor = .lightPink
        $0.layer.cornerRadius = 12.0
    }

    private let peachImage = UIImageView(image: AssetImage.peach.image)

    private let greetingsLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.numberOfLines = 0
        $0.text = AssetString.premiumGreetings.textValue
    }

    // MARK: - Lifecycle

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    @objc
    private func paymentButtonAction() {
        paymentButtonHandler?()
    }

    override func setUp() {
        super.setUp()

        setTarget()

        add {
            pinkView
            tableView
            paymentButton
        }

        pinkView.add {
            peachImage
            greetingsLabel
        }

        pinkView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }

        peachImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
        }

        greetingsLabel.snp.makeConstraints { make in
            make.left.equalTo(peachImage.snp.right).offset(16)
            make.top.equalTo(peachImage)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(pinkView.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(paymentButton.snp.top)
        }

        paymentButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(54)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(40)
        }
    }

    private func setTarget() {
        paymentButton.addTarget(
            self,
            action: #selector(paymentButtonAction),
            for: .touchUpInside
        )
    }
}

extension PremiumView: PremiumViewInput {}
