//
//  SymptomsManager.swift
//  Peach
//
//  Created by Василий on 15.11.2023.
//

import Foundation

final class SymptomsManager {

    // MARK: - Properties

    static let shared = SymptomsManager()

    var symptoms: [Symptoms] = [] {
        didSet {
            save(model: symptoms)
        }
    }

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Initializers

    private init() {
        symptoms = loadSymptoms()
    }

    // MARK: - Instance methods

    func get(date: Date) -> Symptoms? {
        return symptoms.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) } )
    }

    func update(date: Date, symptoms: [IndexPath], note: String) {
        if let index = self.symptoms.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) } ) {
            self.symptoms[index].symptoms = symptoms
            self.symptoms[index].note = note
        }
    }

    func add(model: Symptoms) {
        if !contains(date: model.date) {
            symptoms.append(model)
        }
    }

    func remove(date: Date) {
        if let index = symptoms.firstIndex(where: { $0.date == date }) {
            symptoms.remove(at: index)
        }
    }

    func contains(date: Date) -> Bool {
        return symptoms.contains(where: { $0.date == date })
    }

    private func loadSymptoms() -> [Symptoms] {
        let data = UserDefaults.standard.data(forKey: Config.savedSymptomsKey.rawValue) ?? Data()
        guard let modelForRetrieve = try? decoder.decode([Symptoms].self, from: data)  else { return [] }

        return modelForRetrieve
    }

    private func save(model: [Symptoms]) {
        if let modelForSave = try? encoder.encode(model) {
            UserDefaults.standard.set(modelForSave, forKey: Config.savedSymptomsKey.rawValue)
        }
    }
}
