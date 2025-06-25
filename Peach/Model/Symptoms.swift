//
//  Symptoms.swift
//  Peach
//
//  Created by Василий on 15.11.2023.
//

import Foundation

struct Symptoms: Codable {
    let date: Date
    var symptoms: [IndexPath] = [] // индексы выбранных ячеек
    var note: String // дополнительные симптомы (сетятся в текстфилд)
}
