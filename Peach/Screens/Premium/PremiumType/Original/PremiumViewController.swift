//
//  PremiumViewController.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit

final class PremiumViewController
<View: PremiumViewInput>: BaseViewController<View>,
                            UITableViewDataSource, UITableViewDelegate,
                            UIGestureRecognizerDelegate {

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()

        setupNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
        contentViewActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        contentView.viewModel.input.send(.dismiss)

    }

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    private func contentViewActions() {
        contentView.paymentButtonHandler = { [weak self] in
            self?.contentView.viewModel.input.send(.paymentTap)
        }
        contentView.closeTapHandler = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    private func subscribeDelegates() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }

    // MARK: - UITableViewDataSource methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return contentView.viewModel.paymentCellModel.value.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: PaymentCell.self, for: indexPath)
        cell.configure(model: contentView.viewModel.paymentCellModel.value[indexPath.section])
        contentView.viewModel.cells.value.append(cell)
        return cell
    }

    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentView.viewModel.cells.value.forEach {
            if $0.paymentIsSelected == false {
                $0.paymentIsSelected = true
                contentView.viewModel.paymentID.value = $0.id
            } else {
                $0.paymentIsSelected = false
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension PremiumViewController {

    // MARK: - Instance methods

    private func setupNavigationBar() {
        title = AssetString.premiumAccount.text

        let backButton = UIBarButtonItem(
            image: AssetImage.backArrow.image,
            style: .plain,
            target: navigationController,
            action: #selector(UINavigationController.popViewController(animated:))
        )
        backButton.tintColor = .black

        navigationItem.leftBarButtonItem = backButton
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}
