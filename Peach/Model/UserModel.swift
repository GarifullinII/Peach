//
//  UserModel.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import Foundation

struct UserModel: Codable, Equatable {
    var id = UUID().uuidString
    var name: String? = nil
    var age: Int? = nil
    var birthDate: Date?
    var startCycleDate: Date? = nil
    var cycleDuration: Int? = nil
    
    var isFilled: Bool {
        return name != nil && age != nil && startCycleDate != nil && cycleDuration != nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case age
        case birthDate = "birth_date"
        case startCycleDate = "start_cycle_date"
        case cycleDuration = "cycle_duration"
    }
}
