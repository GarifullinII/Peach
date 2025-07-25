//
//  UserModel.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import Foundation

struct UserModel: Codable {
    var id = UUID().uuidString
    var name: String? = nil
    var age: Int? = nil
    var birth_date: Date?
    var start_cycle_date: Date? = nil
    var cycle_duration: Int? = nil
    
    var isFilled: Bool {
        return name != nil && age != nil && start_cycle_date != nil && cycle_duration != nil
    }
}
