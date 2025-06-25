//
//  BaseCollectionCell.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: .zero)

        setup()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance methods

    func setup() {
        backgroundColor = .white
    }
}
