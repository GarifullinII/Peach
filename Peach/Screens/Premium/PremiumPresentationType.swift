//
//  PresentationType.swift
//  Peach
//
//  Created by Василий on 20.09.2023.
//

import Foundation

enum SheetType {
    case small
    case medium
}

enum PresentationType {
    case big
    case sheet(SheetType?=nil)
}
