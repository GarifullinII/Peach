//
//  Extension + UITextField.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import UIKit

extension UITextField {
    func addIcon(_ image: UIImage, padding: CGFloat, isLeftView: Bool = false) {
        //        let frame = CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height)
        
        // Проверяем валидность размеров изображения и padding
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        guard imageWidth.isFinite && !imageWidth.isNaN && imageWidth > 0 &&
                imageHeight.isFinite && !imageHeight.isNaN && imageHeight > 0 &&
                padding.isFinite && !padding.isNaN else {
            print("⚠️ Warning: Invalid image size or padding in addIcon - width: \(imageWidth), height: \(imageHeight), padding: \(padding)")
            return
        }
        
        let frame = CGRect(x: 0, y: 0, width: imageWidth + padding, height: imageHeight)
        
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
