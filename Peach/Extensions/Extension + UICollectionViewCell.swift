//
//  Extension + UICollectionViewCell.swift
//  Peach
//
//  Created by Василий on 13.09.2023.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
