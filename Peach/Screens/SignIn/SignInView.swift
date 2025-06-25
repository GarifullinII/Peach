//
//  SignInView.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import UIKit
import SnapKit

final class SignInView: BaseContentView<SignInViewModelImpl> {

    // MARK: - Properties

    var continueHandler: (() -> Void)?

    var doneHandler: (() -> Void)?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(type: SignInCell.self)
        return collectionView
    }()

    lazy var pickerView = UIPickerView()

    lazy var doneButton = UIBarButtonItem(
        title: AssetString.done.text,
        style: .plain,
        target: self,
        action: #selector(doneAction)
    )

    private let continueButton = PinkButton(state: .goContinue)

    // MARK: - Lifecycle

    deinit {
        print("❌Deinit:", String(describing: self))
    }
    
    // MARK: - Instance methods

    @objc
    private func continueAction() {
        continueHandler?()
    }

    @objc
    private func hideKeyboardAction() {
        endEditing(true)
    }

    @objc
    private func doneAction() {
        doneHandler?()
    }

    override func setUp() {
        super.setUp()

        setTargets()

        add {
            collectionView
            continueButton
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(450)
        }

        continueButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(54)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }

    func updateConstraint(height: CGFloat) {
        continueButton.snp.updateConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(54)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(height)
        }
    }

    private func setTargets() {
        continueButton.addTarget(
            self,
            action: #selector(continueAction),
            for: .touchUpInside
        )

        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(hideKeyboardAction)
            )
        )
    }
}
