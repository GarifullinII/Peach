//
//  PaymentCell.swift
//  Peach
//
//  Created by Василий on 12.09.2023.
//

import UIKit
import SnapKit

final class PaymentCell: BaseTableCell {
    
    // MARK: - Properties
    
    var id: Int?
    
    var paymentIsSelected: Bool = false {
        didSet {
            contentView.backgroundColor = paymentIsSelected ? .lightPink : .white
            contentView.layer.borderColor =
            paymentIsSelected ? UIColor.mainPink.cgColor : UIColor.borderGray.cgColor
            perMonthLabel.textColor =
            paymentIsSelected ? .mainPink : .borderGray
            checkBoxImage.image =
            paymentIsSelected ? AssetImage.checkBox_fill.image : AssetImage.checkBox.image
            [bigCircleLayer, smallCircleLayer, mediumCircleLayer].forEach {
                $0.isHidden = !paymentIsSelected
            }
        }
    }
    
    private let perYearLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .borderGray
    }
    
    private let perMonthLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private let backView = UIView().then {
        $0.backgroundColor = .lightPink
    }
    
    private let checkBoxImage = UIImageView()
    
    private lazy var stackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            perYearLabel,
            perMonthLabel
        ],
        axis: .vertical,
        distribution: .fillProportionally,
        spacing: 13
    )
    
    // MARK: - Layer properties
    
    private lazy var bigCircleLayer = CAShapeLayer().then {
        let frameMaxX = contentView.frame.maxX
        let safeX = frameMaxX.isFinite && !frameMaxX.isNaN ? frameMaxX - 60 : 315
        
        $0.path = UIBezierPath(
            //            roundedRect: CGRect(x: contentView.frame.maxX - 60,
            roundedRect: CGRect(x: safeX,
                                y: -40,
                                width: 170,
                                height: 170), cornerRadius: 85).cgPath
        $0.fillColor = UIColor.circlePink.cgColor
    }
    
    private lazy var smallCircleLayer = CAShapeLayer().then {
        let frameWidth = contentView.frame.width
        let frameHeight = contentView.frame.height
        let safeWidth = frameWidth.isFinite && !frameWidth.isNaN ? frameWidth : 375
        let safeHeight = frameHeight.isFinite && !frameHeight.isNaN ? frameHeight : 100
        
        $0.path = UIBezierPath(
            //            roundedRect: CGRect(x: (contentView.frame.width / 2) + 50,
            //                                y: (contentView.frame.height / 2) - 10,
            roundedRect: CGRect(x: (safeWidth / 2) + 50,
                                y: (safeHeight / 2) - 10,
                                width: 20,
                                height: 20), cornerRadius: 10).cgPath
        $0.fillColor = UIColor.circlePink.cgColor
    }
    
    private lazy var mediumCircleLayer = CAShapeLayer().then {
        let frameWidth = contentView.frame.width
        let frameHeight = contentView.frame.height
        let safeWidth = frameWidth.isFinite && !frameWidth.isNaN ? frameWidth : 375
        let safeHeight = frameHeight.isFinite && !frameHeight.isNaN ? frameHeight : 100
        
        $0.path = UIBezierPath(
            //            roundedRect: CGRect(x: (contentView.frame.width / 2) + 25,
            //                                y: (contentView.frame.height / 2) + 25,
            roundedRect: CGRect(x: (safeWidth / 2) + 25,
                                y: (safeHeight / 2) + 25,
                                width: 60,
                                height: 60), cornerRadius: 30).cgPath
        $0.fillColor = UIColor.circlePink.cgColor
    }
    
    // MARK: - Instance methods
    
    func configure(model: PaymentCellModel) {
        paymentIsSelected = model.isSelected
        perYearLabel.text = model.paymentPerYear
        perMonthLabel.text = model.paymentPerMonth
        perYearLabel.isHidden = model.paymentPerYear.isEmpty
        id = model.id
    }
    
    override func setup() {
        super.setup()
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16.0
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.borderGray.cgColor
        contentView.clipsToBounds = true
        contentView.layer.addSublayers(
            layers: [bigCircleLayer, smallCircleLayer, mediumCircleLayer]
        )
        
        add {
            stackView
            checkBoxImage
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
        
        checkBoxImage.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(stackView)
        }
    }
}
