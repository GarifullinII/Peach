//
//  Extension + UIStackView.swift
//  Peach
//
//  Created by Василий on 12.09.2023.
//

import UIKit

extension UIStackView {
    convenience init(alignment: UIStackView.Alignment = .fill,
                     arrangedSubviews: [UIView] = [],
                     axis: NSLayoutConstraint.Axis,
                     distribution: UIStackView.Distribution = .fill,
                     spacing: CGFloat = 0) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.alignment = alignment
        self.axis = axis
        self.distribution = distribution
        self.spacing = spacing
    }
}
