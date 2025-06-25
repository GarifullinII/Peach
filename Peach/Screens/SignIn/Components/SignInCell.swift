//
//  SignInCell.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import UIKit
import SnapKit

final class SignInCell: BaseCollectionCell {

    // MARK: - Properties

    var topTextFieldHandler: ((String, Int) -> Void)?

    var bottomTextFieldHandler: ((String) -> Void)?

    var dateHandler: ((Date) -> Void)?

    var index: Int?

    private var topTextField = CommonTextField(state: .name)

    private var bottomTextField = CommonTextField(state: .cycle_duration)

    private let stepLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }

    private let timeLineImage = UIImageView()

    private lazy var timeLineStackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            stepLabel,
            timeLineImage
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 10
    )

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private let datePicker = UIDatePicker()

    // MARK: - Instance methods

    @objc
    private func doneButtonAction() {
        endEditing(true)
        dateHandler?(datePicker.date)
        setDate()
    }

    func configure(model: SignInCellModel, index: Int) {
        self.stepLabel.text = model.step
        self.timeLineImage.image = model.timelineImage
        self.titleLabel.text = model.title
        self.bottomTextField.isHidden = model.id != 2
        self.index = index

        switch index {
        case 1:
            topTextField.stateTF = .age
        case 2:
            topTextField.stateTF = .cycle_start_date
            createDatePicker()
        default:
            break
        }
    }

    override func setup() {
        super.setup()

        textFieldActions()

        add {
            timeLineStackView
            titleLabel
            topTextField
            bottomTextField
        }

        timeLineStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLineStackView.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().inset(30)
        }

        topTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }

        bottomTextField.snp.makeConstraints { make in
            make.top.equalTo(topTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }

        timeLineImage.snp.makeConstraints { make in
            make.width.equalTo(timeLineStackView)
        }
    }

    private func textFieldActions() {
        topTextField.textDidChange = { [weak self] text in
            guard let self else { return }

            if let index = self.index {
                self.topTextFieldHandler?(text, index)
            }
        }

        bottomTextField.textDidChange = { [weak self] text in
            self?.bottomTextFieldHandler?(text)
        }
    }

    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        let doneButton = UIBarButtonItem(
            title: AssetString.done.text,
            style: .plain,
            target: self,
            action: #selector(doneButtonAction)
        )
        toolBar.setItems([spaceButton, doneButton], animated: true)

        return toolBar
    }

    private func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        topTextField.inputView = datePicker
        topTextField.inputAccessoryView = createToolBar()
    }

    private func setDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        topTextField.text = dateFormatter.string(from: datePicker.date)
    }
}
