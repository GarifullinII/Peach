//
//  SymptomsView.swift
//  Peach
//
//  Created by Василий on 22.09.2023.
//

import UIKit
import SnapKit

final class SymptomsView: BaseContentView<SymptomsViewModelImpl> {

    // MARK: - Properties

    var saveHandler: (() -> Void)?

    lazy var collectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 6
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        layout.headerReferenceSize = CGSize(width: frame.size.width, height: 40)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(type: SymptomCell.self)
        collectionView.register(view: HeaderView.self)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    let textField = CommonTextField(state: .write_smth)

    private let addSymptomLabel = UILabel().then {
        $0.text = AssetString.add_symptom.text
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }

    private let saveButton = PinkButton(state: .save)

    private lazy var bottomStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            addSymptomLabel,
            textField,
            saveButton
        ],
        axis: .vertical,
        distribution: .fill,
        spacing: 15)

    // MARK: - Lifecycle

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    @objc
    private func saveAction() {
        saveHandler?()
    }

    override func setUp() {
        super.setUp()

        setupSubviews()
        setupTarget()
        configure(viewModel: viewModel.retrieveSymptomModel)
    }

    func configure(viewModel: Symptoms?) {
        if let viewModel = viewModel {
            textField.text = viewModel.note
        }
    }
    
    private func setupSubviews() {
        add {
            collectionView
            bottomStackView
        }

        saveButton.snp.makeConstraints { make in
            make.height.equalTo(54)
        }

        bottomStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(bottomStackView.snp.top).offset(-20)
        }
    }

    private func setupTarget() {
        saveButton.addTarget(
            self,
            action: #selector(saveAction),
            for: .touchUpInside
        )
    }
}
