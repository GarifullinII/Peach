//
//  Extension + UITableView.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit

extension UITableView {
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(type, forCellReuseIdentifier: identifier ?? cellId)
    }

    func dequeueCell<T: UITableViewCell>(withType type: T.Type = T.self, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: type.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(type.reuseIdentifier) matching type \(type.self).")
        }
        return cell
    }
}
