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
            case .age: return .numberPad
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
        
        var usesDatePicker: Bool {
            return self == .birthDate || self == .cycleStartDate
        }
    }
    
    var fieldState: TextFieldState = .name {
        didSet { configure() }
    }
    
    var textDidChange: ((String) -> Void)?
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        
        // Устанавливаем минимальную и максимальную даты
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Максимальная дата - текущая дата (1 июля 2025)
        picker.maximumDate = currentDate
        
        // Минимальная дата - 1 июля 1925
        var components = DateComponents()
        components.year = 1925
        components.month = 7
        components.day = 1
        picker.minimumDate = calendar.date(from: components)
        
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
    
    var onDateSelected: ((Date) -> Void)?
    
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
    }
    
    private func configure() {
        placeholder = fieldState.placeholderText
        keyboardType = fieldState.keyboardType
        
        inputView = nil
        inputAccessoryView = nil
        
        if let icon = fieldState.rightIcon {
            let button = UIButton(type: .custom)
            button.setImage(icon, for: .normal)
            button.addTarget(self, action: #selector(calendarIconTapped), for: .touchUpInside)
            
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
            button.frame = container.bounds
            container.addSubview(button)
            
            rightView = container
            rightViewMode = .always
            
            if fieldState.usesDatePicker {
                inputView = datePicker
                inputAccessoryView = toolbar
            }
        } else {
            rightView = nil
            rightViewMode = .never
        }
    }
    
    @objc private func calendarIconTapped() {
        guard fieldState.usesDatePicker else { return }
        becomeFirstResponder()
    }
    
    @objc private func doneButtonTapped() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        text = formatter.string(from: datePicker.date)
        onDateSelected?(datePicker.date)
        resignFirstResponder()
    }
    
    @objc private func editingDidBegin() {
        if fieldState == .age && !isShowingDatePicker {
            inputView = nil
            inputAccessoryView = nil
        }
    }
    
    @objc private func editingDidEnd() {
        isShowingDatePicker = false
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        textDidChange?(sender.text ?? "")
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
