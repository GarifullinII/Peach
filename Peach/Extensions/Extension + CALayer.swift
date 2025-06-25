//
//  Extension + CALayer.swift
//  Peach
//
//  Created by Василий on 12.09.2023.
//

import UIKit

extension CALayer {
    func addSublayers(layers: [CALayer]) {
        layers.forEach {
            addSublayer($0)
        }
    }
}
