//
//  PremiumViewInput.swift
//  Peach
//
//  Created by Василий on 20.09.2023.
//

import UIKit

protocol PremiumViewInput: UIView {
    var paymentButtonHandler: (() -> Void)? { get set }
    var closeTapHandler: (() -> Void)? { get set }
    var viewModel: PremiumViewModelImpl { get }
    var tableView: UITableView { get }

    func configure(type: SheetType)
}
