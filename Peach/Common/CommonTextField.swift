//
//  CommonTextField.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import UIKit
import SnapKit

final class CommonTextField: UITextField {

    // MARK: - Nested types

    enum State {
        case name
        case age
        case cycle_start_date
        case cycle_duration
        case write_smth

        var text: String {
            switch self {
            case .name:
                return AssetString.what_is_your_name.text
            case .age:
                return AssetString.how_old_are_you.text
            case .cycle_start_date:
                return AssetString.select_date.text
            case .cycle_duration:
                return AssetString.cycle_duration.text
            case .write_smth:
                return AssetString.write_smth.text
            }
        }

        var keyboardType: UIKeyboardType {
            switch self {
            case .age, .cycle_duration:
                return .numberPad
            default:
                return .default
            }
        }

        var image: UIImage {
            switch self {
            case .age, .cycle_start_date:
                return AssetImage.calendar_small_icon.image
            case .cycle_duration:
                return AssetImage.drop_arrow_icon.image
            default:
                return UIImage()
            }
        }
    }

    // MARK: - Properties

    var textDidChange: ((String) -> Void)?

    var stateTF: State = .name {
        didSet {
            setup(with: stateTF)
        }
    }

    var textPadding = UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 10
    )

    // MARK: - Initializers

    init(state: State) {
        super.init(frame: .zero)

        stateTF = state
        setSelf()
        setup(with: state)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -

    private func setup(with state: State) {
        placeholder = state.text
        keyboardType = state.keyboardType
        addIcon(state.image, padding: 25)
    }

    private func setSelf() {
        layer.cornerRadius = 16.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.borderGray.cgColor
        backgroundColor = .white
        addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)

        self.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
    }

    @objc
    private func textDidChange(_ sender: UITextField) {
        textDidChange?(sender.text ?? "")
    }

    // MARK: - UITextField Methods

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
