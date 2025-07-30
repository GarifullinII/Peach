//
//  SymptomCell.swift
//  Peach
//
//  Created by Василий on 22.09.2023.
//

import UIKit
import SnapKit

enum SymptomCellType: Codable {
    case pink
    case blue
    case red
    case none

    var textColor: UIColor {
        switch self {
        case .pink:
            return .mainPink
        case .blue:
            return .textBlue
        case .red:
            return .red
        default:
            return .clear
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .pink, .red:
            return .lightPink
        case .blue:
            return .blueBackground
        default:
            return .clear
        }
    }

    var selectedTextBackgroundColor: UIColor {
        switch self {
        case .pink:
            return .mainPink
        case .blue:
            return .textBlue
        case .red:
            return .red
        default:
            return .clear
        }
    }
}


final class SymptomCell: BaseCollectionCell {

    // MARK: - Properties

    var isChoosen: Bool = false {
        didSet {
            backgroundColor = isChoosen ? cellType.selectedTextBackgroundColor : cellType.backgroundColor
            titleLabel.textColor = isChoosen ? .white : cellType.textColor
        }
    }

    var cellType: SymptomCellType = .none

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }

    // MARK: - Instance methods

    func configure(type: BaseSymptomsInput) {
        if isChoosen {
            backgroundColor = type.type.selectedTextBackgroundColor
            titleLabel.textColor = .white
        } else {
            backgroundColor = type.type.backgroundColor
            titleLabel.textColor = type.type.textColor
        }
        titleLabel.text = type.title
        titleLabel.numberOfLines = 1
        cellType = type.type
    }

    func toggle() {
        isChoosen = !isChoosen
    }

    override func setup() {
        super.setup()

        layer.cornerRadius = 16.0

        setupSubviews()
    }

    private func setupSubviews() {
        add {
            titleLabel
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
