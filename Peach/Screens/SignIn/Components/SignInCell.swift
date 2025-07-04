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
    var dateHandler: ((Date, Int) -> Void)?
    var index: Int?
    
    private var topTextField = CommonTextField(fieldState: .name)
    private var bottomTextField = CommonTextField(fieldState: .cycleDuration)
    
    private let stepLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private let timeLineImage = UIImageView()
    
    private lazy var timeLineStackView = UIStackView(
        arrangedSubviews: [stepLabel, timeLineImage]
    ).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.spacing = 10
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 28, weight: .bold)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    // MARK: - Lifecycle
    
    override func setup() {
        super.setup()
        setupViews()
        setupConstraints()
        textFieldActions()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topTextField.setNeedsLayout()
        topTextField.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            topTextField.text = nil
            bottomTextField.text = nil
            bottomTextField.isHidden = true
            topTextFieldHandler = nil
            bottomTextFieldHandler = nil
            dateHandler = nil
            index = nil
        }
    
    // MARK: - Configuration
    
    func configure(model: SignInCellModel, index: Int) {
        self.stepLabel.text = model.step
                self.timeLineImage.image = model.timelineImage
                self.titleLabel.text = model.title
                self.index = index
                
                // Сбрасываем обработчики перед настройкой
                topTextField.onDateSelected = nil
                bottomTextField.onValueSelected = nil
                
                switch index {
                case 0:
                    topTextField.fieldState = .name
                    bottomTextField.isHidden = true
                case 1:
                    topTextField.fieldState = .birthDate
                    bottomTextField.isHidden = true
                    topTextField.onDateSelected = { [weak self] date in
                        self?.dateHandler?(date, index)
                    }
                case 2:
                    topTextField.fieldState = .cycleStartDate
                    bottomTextField.fieldState = .cycleDuration
                    bottomTextField.isHidden = false
                    topTextField.onDateSelected = { [weak self] date in
                        self?.dateHandler?(date, index)
                    }
                    bottomTextField.onValueSelected = { [weak self] value in
                        self?.bottomTextFieldHandler?("\(value)")
                    }
                default:
                    topTextField.fieldState = .name
                    bottomTextField.isHidden = true
                }
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        addSubview(timeLineStackView)
        addSubview(titleLabel)
        addSubview(topTextField)
        addSubview(bottomTextField)
    }
    
    private func setupConstraints() {
        timeLineStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(timeLineStackView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        topTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        bottomTextField.snp.makeConstraints {
            $0.top.equalTo(topTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        timeLineImage.snp.makeConstraints {
            $0.width.equalTo(timeLineStackView)
        }
    }
    
    private func textFieldActions() {
        topTextField.textDidChange = { [weak self] text in
            guard let self = self, let index = self.index else { return }
            self.topTextFieldHandler?(text, index)
        }
        
        bottomTextField.textDidChange = { [weak self] text in
            self?.bottomTextFieldHandler?(text)
        }
    }
}
