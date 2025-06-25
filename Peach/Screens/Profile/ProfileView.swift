//
//  ProfileView.swift
//  Peach
//
//  Created by Василий on 07.09.2023.
//

import UIKit
import SnapKit

final class ProfileView: BaseContentView<ProfileViewModelImpl> {

    // MARK: - Properties

    var premiumTapHanler: (() -> Void)?

    var signOutHandler: (() -> Void)?

    lazy var tableView = UITableView().then {
        $0.registerCell(type: ProfileCell.self)
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.backgroundColor = .backgroundGray
    }
    
    private let premiumImage = UIImageView(image: AssetImage.profilePremium.image).then {
        $0.isUserInteractionEnabled = true
    }

    private let signOutButton = UIButton().then {
        $0.setTitle(AssetString.exit.text, for: .normal)
        $0.setTitleColor(.red, for: .normal)
    }

    private let avatarImage = UIImageView(image: AssetImage.avatar.image)

    private let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }

    private let ageLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .textGray
    }

    private let backgroundView = UIView().then {
        $0.backgroundColor = .backgroundGray
        $0.layer.cornerRadius = 24
    }

    private let addPremiumLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.text = AssetString.connectPreemium.text
        $0.textColor = .white
    }

    private let firstQuestionsFreeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.text = AssetString.first_quiestions_free.text
        $0.numberOfLines = 0
        $0.textColor = .white
    }

    // MARK: - Lifecycle

    deinit {
        print("❌Deinit \(String(describing: self))")
    }

    // MARK: - Instance methods

    @objc
    private func premiumTapAction(_ sender: UIGestureRecognizer) {
        premiumTapHanler?()
    }

    @objc
    private func signOutAction() {
        signOutHandler?()
    }
    
    func configure(model: UserModel?) {
        guard let model else { return }
        
        nameLabel.text = model.name
        ageLabel.text = String(model.age ?? 0)
    }

    override func setUp() {
        super.setUp()

        setTargets()
        
        add {
            avatarImage
            nameLabel
            ageLabel
            backgroundView
        }
        
        backgroundView.add {
            premiumImage
            tableView
            signOutButton
        }

        premiumImage.add {
            addPremiumLabel
            firstQuestionsFreeLabel
        }
        
        avatarImage.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(avatarImage)
            make.top.equalTo(avatarImage.snp.bottom).offset(9)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.centerX.equalTo(avatarImage)
            make.top.equalTo(nameLabel.snp.bottom).offset(9)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(20)
            make.left.bottom.right.equalToSuperview()
        }
        
        premiumImage.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).offset(15)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(premiumImage.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }

        signOutButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        addPremiumLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(16)
        }

        firstQuestionsFreeLabel.snp.makeConstraints { make in
            make.top.equalTo(addPremiumLabel.snp.bottom).offset(10)
            make.left.equalTo(addPremiumLabel)
            make.width.equalTo(140)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    private func setTargets() {
        premiumImage.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(premiumTapAction(_ :)))
        )

        signOutButton.addTarget(
            self,
            action: #selector(signOutAction)
            , for: .touchUpInside
        )
    }
}
