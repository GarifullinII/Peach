//
//  Extension + Locale.swift
//  Peach
//
//  Created by Василий on 12.09.2023.
//

import Foundation

extension Locale {
    var isEnglish: Bool {
        if #available(iOS 16, *) {
            return language.languageCode?.identifier == "en"
        } else {
            return languageCode == "en"
        }
    }
}
