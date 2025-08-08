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
    private var currentUserID: String? = nil
    
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
        let symptom = symptoms.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) } )
        if let symptom = symptom, !symptom.note.isEmpty {
            print("Отображение симптома для даты \(date): \(symptom.note)")
        }
        return symptom
    }
    
    func update(date: Date, symptoms: [IndexPath], note: String, userSymptoms: [String] = []) {
        if let index = self.symptoms.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) } ) {
            self.symptoms[index].symptoms = symptoms
            self.symptoms[index].note = note
            self.symptoms[index].userSymptoms = userSymptoms
            
            if !note.isEmpty {
                print("Обновлен симптом для даты \(date): \(note)")
            }
            
            if !userSymptoms.isEmpty {
                            print("Обновлены пользовательские симптомы для даты \(date): \(userSymptoms.joined(separator: ", "))")
                        }
        }
    }
    
    func add(model: Symptoms) {
        if !contains(date: model.date) {
            symptoms.append(model)
            
            if !model.note.isEmpty {
                print("Добавлен новый симптом для даты \(model.date): \(model.note)")
            }
            
            if !model.userSymptoms.isEmpty {
                            print("Добавлены пользовательские симптомы для даты \(model.date): \(model.userSymptoms.joined(separator: ", "))")
                        }
        }
    }
    
    func remove(date: Date) {
        if let index = symptoms.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            symptoms.remove(at: index)
        }
    }
    
    func contains(date: Date) -> Bool {
        return symptoms.contains(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
    }
    
    private func loadSymptoms() -> [Symptoms] {
//        let data = UserDefaults.standard.data(forKey: Config.savedSymptomsKey.rawValue) ?? Data()
        guard let userID = currentUserID else { return [] }
                let data = UserDefaults.standard.data(forKey: "\(Config.savedSymptomsKey.rawValue)_\(userID)") ?? Data()
                guard let modelForRetrieve = try? decoder.decode([Symptoms].self, from: data)  else { return [] }
                
                return modelForRetrieve
    }
    
    private func save(model: [Symptoms]) {
        guard let userID = currentUserID else { return }
                if let modelForSave = try? encoder.encode(model) {
                    // Сохранение симптомов введенных пользователем
                    UserDefaults.standard.set(modelForSave, forKey: "\(Config.savedSymptomsKey.rawValue)_\(userID)")
                }
    }
    
    func setCurrentUser(_ userID: String?) {
            currentUserID = userID
        }
        
        func clearUserData() {
            guard let userID = currentUserID else { return }
            UserDefaults.standard.removeObject(forKey: "\(Config.savedSymptomsKey.rawValue)_\(userID)")
        }
}
