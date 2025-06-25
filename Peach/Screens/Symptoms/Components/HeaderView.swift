//
//  HeaderView.swift
//  Peach
//
//  Created by Василий on 02.10.2023.
//

import UIKit
import SnapKit

final class HeaderView: UICollectionReusableView {

    // MARK: - Properties

    private let label = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .black
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Instance methods

    func configure(text: String) {
        label.text = text
    }

    private func setupSubviews() {
        add { label }

        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
