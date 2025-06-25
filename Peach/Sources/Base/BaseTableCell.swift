//
//  BaseTableCell.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit

class BaseTableCell: UITableViewCell {

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance methods

    func setup() {
        contentView.backgroundColor = .white
        selectionStyle = .none
    }
}
