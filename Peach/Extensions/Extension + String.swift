//
//  Extension + String.swift
//  Peach
//
//  Created by Василий on 09.10.2023.
//

import Foundation

extension String {
    func removeFirstSpaces() -> String {
        replacingOccurrences(of: "\n", with: "")
    }
}
