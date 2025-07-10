//
//  CommonTextField.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import UIKit
import SnapKit

final class CommonTextField: UITextField {
    
    enum TextFieldState {
        case name
        case age
        case birthDate
        case cycleStartDate
        case cycleDuration
        case writeSomething
        
        var placeholderText: String {
            switch self {
            case .name: return AssetString.what_is_your_name.text
            case .age: return AssetString.how_old_are_you.text
            case .birthDate: return AssetString.select_birth_date.text
            case .cycleStartDate: return AssetString.select_date.text
            case .cycleDuration: return AssetString.cycle_duration.text
            case .writeSomething: return AssetString.write_smth.text
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .age, .cycleDuration: return .numberPad
            default: return .default
            }
        }
        
        var rightIcon: UIImage? {
            switch self {
            case .age, .birthDate, .cycleStartDate:
                return AssetImage.calendar_small_icon.image
            case .cycleDuration:
                return AssetImage.drop_arrow_icon.image
            default:
                return nil
            }
        }
        
        var iconSize: CGSize {
            switch self {
            case .age, .birthDate, .cycleStartDate, .cycleDuration:
                return CGSize(width: 40, height: 30)
            default:
                return .zero
            }
        }
        
        var usesDatePicker: Bool {
            return self == .birthDate || self == .cycleStartDate
        }
    }
    
    var fieldState: TextFieldState = .name {
        didSet { configure() }
    }
    
    var textDidChange: ((String) -> Void)?
    var onDateSelected: ((Date) -> Void)?
    var onValueSelected: ((Int) -> Void)?
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        let calendar = Calendar.current
        picker.maximumDate = Date()
        var components = DateComponents()
        components.year = 1925
        components.month = 7
        components.day = 1
        picker.minimumDate = calendar.date(from: components)
        return picker
    }()
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneButton
        ], animated: false)
        return toolbar
    }()
    
    private var isShowingDatePicker = false
    
    init(fieldState: TextFieldState) {
        super.init(frame: .zero)
        self.fieldState = fieldState
        commonSetup()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonSetup() {
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        backgroundColor = .white
        
        addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        accessibilityLabel = fieldState.placeholderText
        accessibilityHint = "Введите или выберите \(fieldState.placeholderText.lowercased())"
    }
    
    private func configure() {
        placeholder = fieldState.placeholderText
                keyboardType = fieldState.keyboardType
                inputView = nil
                inputAccessoryView = nil
                
                if let icon = fieldState.rightIcon {
                    let button = UIButton(type: .custom)
                    button.setImage(icon, for: .normal)
                    button.addTarget(self, action: #selector(iconTapped), for: .touchUpInside)
                    
                    let iconSize = fieldState.iconSize
                    let container = UIView(frame: CGRect(
                        origin: .zero,
                        size: iconSize
                    ))
                    button.frame = container.bounds
                    container.addSubview(button)
                    
                    rightView = container
                    rightViewMode = .always
                    
                    if fieldState.usesDatePicker {
                        inputView = datePicker
                        inputAccessoryView = toolbar
                    } else if fieldState == .cycleDuration {
                        inputView = pickerView
                        inputAccessoryView = toolbar
                    } else if fieldState == .age {
                        inputView = nil
                        inputAccessoryView = toolbar
                    }
                } else {
                    rightView = nil
                    rightViewMode = .never
                }
                
                if fieldState == .cycleStartDate {
                    let calendar = Calendar.current
                    datePicker.minimumDate = calendar.date(byAdding: .day, value: -365, to: Date())
                }
    }
    
    @objc private func iconTapped() {
        if fieldState.usesDatePicker || fieldState == .cycleDuration {
            becomeFirstResponder()
        }
    }
    
    @objc private func doneButtonTapped() {
        if fieldState == .cycleDuration {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let value = selectedRow
            text = "\(value)"
            onValueSelected?(value)
        } else if fieldState.usesDatePicker {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            text = formatter.string(from: datePicker.date)
            onDateSelected?(datePicker.date)
        }
        resignFirstResponder()
    }
    
    @objc private func editingDidBegin() {
        isShowingDatePicker = fieldState.usesDatePicker
                if fieldState == .name || fieldState == .writeSomething {
                    inputView = nil
                    inputAccessoryView = nil
                }
    }
    
    @objc private func editingDidEnd() {
        isShowingDatePicker = false
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        if fieldState == .cycleDuration, let text = sender.text, let value = Int(text) {
                    if value < 0 || value > 50 {
                        sender.text = ""
                        onValueSelected?(0)
                    } else {
                        onValueSelected?(value)
                    }
                } else if fieldState == .age, let text = sender.text, let value = Int(text) {
                    if value < 10 {
                        sender.text = ""
                        textDidChange?("")
                    } else {
                        textDidChange?(text)
                    }
                } else {
                    textDidChange?(sender.text ?? "")
                }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 40))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 40))
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 16
        return rect
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension CommonTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 51 // 0–50
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text = "\(row)"
        onValueSelected?(row)
    }
}
