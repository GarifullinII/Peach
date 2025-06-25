//
//  Extension + UITableViewCell.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
