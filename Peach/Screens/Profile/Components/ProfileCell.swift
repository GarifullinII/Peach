//
//  ProfileCell.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit

final class ProfileCell: BaseTableCell {

    // MARK: - Properties

    private let iconImage = UIImageView()

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }

    private let arrowImage = UIImageView().then {
        $0.image = AssetImage.right_arrow.image
    }

    // MARK: - Instance methods

    func configure(model: ProfileCellModel) {
        iconImage.image = model.image
        titleLabel.text = model.title
    }

    override func setup() {
        super.setup()

        backgroundColor = .backgroundGray

        contentView.layer.cornerRadius = 16.0

        contentView.add {
            iconImage
            titleLabel
            arrowImage
        }

        iconImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.left.equalTo(iconImage.snp.right).offset(10)
        }

        arrowImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.right.equalTo(contentView).inset(16)
        }
    }
}
