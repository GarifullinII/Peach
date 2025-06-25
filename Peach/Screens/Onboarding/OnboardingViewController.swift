//
//  OnboardingViewController.swift
//  Peach
//
//  Created by Василий on 13.09.2023.
//

import UIKit

final class OnboardingViewController
<View: OnboardingView>: BaseViewController<View>, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties

    private lazy var continueHandler = { (index: Int) in
        let range = 0..<self.contentView.viewModel.onboadings.value.count - 1

        if range.contains(index) {
            self.contentView.collectionView.scrollToItem(
                at: [0, index + 1],
                at: .right, animated: true
            )
        } else if index == 2 {
            self.contentView.viewModel.input.send(.signIn)
        }
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()

        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
        contentViewAction()
    }

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }

    private func contentViewAction() {
        contentView.skipHandler = { [weak self] in
            self?.contentView.viewModel.input.send(.signIn)
        }
    }

    // MARK: - UICollectionViewDataSource methods

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return contentView.viewModel.onboadings.value.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(withType: OnboardingCell.self, for: indexPath)
        cell.configure(model: contentView.viewModel.onboadings.value[indexPath.item])
        cell.index = indexPath.item
        cell.continueHandler = continueHandler
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout methods

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentView.frame.width, height: contentView.frame.height)
    }
}
