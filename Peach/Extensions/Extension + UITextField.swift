//
//  Extension + UITextField.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import UIKit

extension UITextField {
    func addIcon(_ image: UIImage, padding: CGFloat, isLeftView: Bool = false) {
        let frame = CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height)

        let outerView = UIView(frame: frame)
        let iconView  = UIImageView(frame: frame)
        iconView.image = image
        iconView.contentMode = .center
        outerView.addSubview(iconView)

        if isLeftView {
            leftViewMode = .always
            leftView = outerView
        } else {
            rightViewMode = .always
            rightView = outerView
        }
    }
}
