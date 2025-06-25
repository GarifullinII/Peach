//
//  OnboardingView.swift
//  Peach
//
//  Created by Василий on 13.09.2023.
//

import UIKit
import SnapKit

final class OnboardingView: BaseContentView<OnboardingViewModelImpl> {

    // MARK: - Properties

    var skipHandler: (() -> Void)?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.indicatorStyle = .default
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerCell(type: OnboardingCell.self)
        return collectionView
    }()

    private let skipButton = UIButton().then {
        $0.setTitle(AssetString.skip.text, for: .normal)
        $0.setTitleColor(.skipGray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    }

    // MARK: - Lifecycle

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    @objc
    private func skipAction() {
        skipHandler?()
    }

    override func setUp() {
        super.setUp()

        setTarget()

        add {
            skipButton
            collectionView
        }

        skipButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.right.equalToSuperview().inset(30)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(skipButton.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        }
    }

    private func setTarget() {
        skipButton.addTarget(
            self,
            action: #selector(skipAction),
            for: .touchUpInside
        )
    }
}
