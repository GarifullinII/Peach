//
//  SympotmsEvents.swift
//  Peach
//
//  Created by Василий on 22.09.2023.
//

import Foundation

enum SymptomsInput {
    case refreshModel(IndexPath)
    case addAdditionalSymptom(String)
    case save
    case dismiss
}

enum SymptomsOutput {
    case dismiss
    case clearTextField
}
