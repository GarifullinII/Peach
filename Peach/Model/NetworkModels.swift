//
//  NetworkModels.swift
//  Peach
//
//  Created by Ildar Garifullin on 10.07.2025.
//

import Foundation

struct ProfileModel: Codable {
    let id: String
    let name: String
    let age: Int
}

struct SymptomModel: Codable {
    let id: String
    let name: String
}

struct ChatMessageModel: Codable {
    let id: String
    let sender: String
    let message: String
    let date: Date
}

struct PremiumStatusModel: Codable {
    let isActive: Bool
    let expirationDate: Date?
}

struct CalendarEventModel: Codable {
    let id: String
    let title: String
    let date: Date
}

struct OnboardingModel: Codable {
    let id: String
    let title: String
    let description: String
}
