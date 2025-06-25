//
//  UnderDevelopment.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit
import SnapKit

final class UnderDevelopmentViewController: UIViewController {

    // MARK: - Properties

    private let titleLabel = UILabel().then {
        $0.text = AssetString.underDevelopment.text
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    // MARK: - Instance methods

    private func setup() {
        title =  AssetString.underDevelopment.text
        view.backgroundColor = .gray

        view.add {
            titleLabel
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
