//
//  Presentable.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController? {
        self
    }
}
