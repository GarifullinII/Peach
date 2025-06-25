//
//  Reusable.swift
//  Peach
//
//  Created by Василий on 02.10.2023.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String { String(describing: self) }
}

extension UIView: Reusable { }
