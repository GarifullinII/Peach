//
//  Extension + NSLayoutConstraint.swift
//  Peach
//
//  Created by Василий on 19.09.2023.
//

import UIKit

extension NSLayoutConstraint {
    func prioritize(at priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
