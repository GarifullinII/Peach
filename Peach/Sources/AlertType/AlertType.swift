//
//  AlertType.swift
//  Peach
//
//  Created by Василий on 15.09.2023.
//

import Foundation

enum AlertType {
    case fill_all_fields

    var title: String {
        switch self {
        case .fill_all_fields:
            return AssetString.fill_all_fields.text
        }
    }
}
