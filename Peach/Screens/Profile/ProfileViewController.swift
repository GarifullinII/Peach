//
//  ProfileViewController.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit
import Combine

final class ProfileViewController<View: ProfileView>:
    BaseViewController<View>, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
        contentViewActions()
        configure()
    }

    deinit {
        print("❌Deinit \(String(describing: self))")
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }

    private func contentViewActions() {
        contentView.premiumTapHanler = { [weak self] in
            self?.contentView.viewModel.input.send(.premiumTap)
        }

        contentView.signOutHandler = { [weak self] in
            self?.contentView.viewModel.input.send(.signOut)
        }
    }

    private func configure() {
        contentView.configure(model: contentView.viewModel.userModel.value)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return contentView.viewModel.profileCellModel.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: ProfileCell.self, for: indexPath)
        cell.configure(model: contentView.viewModel.profileCellModel.value[indexPath.section])
        return cell
    }

    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            contentView.viewModel.input.send(.assistantTap)
        case 1:
            contentView.viewModel.input.send(.healthReportTap)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        return view
    }
}
