//
//  UserDefaultsManager.swift
//  Peach
//
//  Created by Василий on 12.09.2023.
//

import Foundation

final class UserDefaultsManager {

    // MARK: - Properties

    static let shared = UserDefaultsManager()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Initializers

    private init() {}

    // MARK: - Instance methods

    func load<T: Codable>(_ to: T.Type, _ key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: key),
           let element = try? decoder.decode(T.self, from: data) {
           return element
        } else {
            return nil
        }
    }

    func save<T>(_ element: T, _ key: String) where T : Decodable, T : Encodable {
        if let data = try? encoder.encode(element) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func remove(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
