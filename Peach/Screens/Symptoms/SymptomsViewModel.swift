//
//  SymptomsViewModel.swift
//  Peach
//
//  Created by Василий on 22.09.2023.
//

import Combine
import UIKit

protocol SymptomsViewModel: AnyObject {
    var input: PassthroughSubject<SymptomsInput, Never> { get }
    var output: PassthroughSubject<SymptomsOutput, Never> { get }
}

final class SymptomsViewModelImpl: BaseViewModel, SymptomsViewModel {
    
    // MARK: - Properties
    
    var input = PassthroughSubject<SymptomsInput, Never>()
    var output = PassthroughSubject<SymptomsOutput, Never>()
    
    var dataSource = CurrentValueSubject<BaseSymptomsModel?, Never>(nil)
    var headerDataSource = CurrentValueSubject<[String], Never>([])
    
    var selectedSymptoms: [IndexPath: Bool] = [:]
    var additionalSymptom: String = ""
    var userSymptoms: [String] = [] // Массив пользовательских симптомов
    
    var retrieveSymptomModel: Symptoms?
    
    private let currentDate: Date
    
    // MARK: - Initializers
    
    init(date: Date) {
        self.currentDate = date
        
        super.init()
        
        bind()
        setup()
        load(date: date)
    }
    
    deinit {
        print("❌Deinit:", String(describing: self))
    }
    
    // MARK: - Instance methods
    
    private func setup() {
        //        dataSource.value = BaseSymptomsModel.model.first
        updateDataSource()
        
        headerDataSource.value = [
            AssetString.symptoms.text,
            AssetString.discharge.text,
            AssetString.profuse_bleeding.text,
            AssetString.my_symptoms.text
        ]
    }
    
    private func updateDataSource() {
        let baseModel = BaseSymptomsModel.model.first!
        let userSymptomsModels = userSymptoms.map { BaseSymptom(title: $0, type: .pink) }
        
        let updatedModel = BaseSymptomsModel(
            symptoms: baseModel.symptoms,
            discharge: baseModel.discharge,
            profuseBleeding: baseModel.profuseBleeding,
            mySymptoms: userSymptomsModels
        )
        
        dataSource.value = updatedModel
        
        // Очищаем старые записи для раздела "Мои симптомы"
        selectedSymptoms = selectedSymptoms.filter { $0.key.section != 3 }
        
        // Устанавливаем пользовательские симптомы как активные
        for (index, _) in userSymptoms.enumerated() {
            let indexPath = IndexPath(row: index, section: 3)
            selectedSymptoms[indexPath] = true
        }
    }
    
    private func bind() {
        input.sink { [weak self] input in
            guard let self else { return }
            
            switch input {
            case .refreshModel(let indexPath):
                // Если это раздел "Мои симптомы" (секция 3), удаляем симптом
                if indexPath.section == 3 {
                    removeUserSymptom(at: indexPath)
                } else {
                    // Обычная логика для других разделов
                    if selectedSymptoms.contains(where: {$0.key == indexPath} ) {
                        selectedSymptoms[indexPath] = nil
                    } else {
                        selectedSymptoms[indexPath] = true
                    }
                }
            case .addAdditionalSymptom(let additionalSymptom):
                self.additionalSymptom = additionalSymptom
                if !additionalSymptom.isEmpty {
                    print("Пользователь ввел в поле 'Напишите что-нибудь': \(additionalSymptom)")
                    // Добавляем новый симптом, если его еще нет в списке
                    if !userSymptoms.contains(additionalSymptom) {
                        var updatedSymptoms = userSymptoms
                        updatedSymptoms.append(additionalSymptom)
                        updateUserSymptoms(updatedSymptoms)
                        // Очищаем текстовое поле после добавления симптома
                        self.output.send(.clearTextField)
                    }
                }
            case .save:
                self.save()
            case .dismiss:
                self.output.send(.dismiss)
            }
        }.store(in: &cancellables)
        
        //        input.sink { [weak self] input in
        //            guard let self else { return }
        //
        //            switch input {
        //            case .refreshModel(let indexPath):
        //                if selectedSymptoms.contains(where: {$0.key == indexPath} ) {
        //                    selectedSymptoms[indexPath] = nil
        //                } else {
        //                    selectedSymptoms[indexPath] = true
        //                }
        //            case .addAdditionalSymptom(let additionalSymptom):
        //                self.additionalSymptom = additionalSymptom
        //                if !additionalSymptom.isEmpty {
        //                                    print("Пользователь ввел в поле 'Напишите что-нибудь': \(additionalSymptom)")
        //                                    // Отображаем весь введенный текст как один симптом
        //                                    updateUserSymptoms([additionalSymptom])
        //                                } else {
        //                                    updateUserSymptoms([])
        //                                }
        //            case .save:
        //                self.save()
        //            case .dismiss:
        //                self.output.send(.dismiss)
        //            }
        //        }.store(in: &cancellables)
    }
    
    private func save() {
        // Выводим информацию о выбранных симптомах
        print("Выбранные симптомы пользователем ===")
        print("Дата: \(currentDate)")
        
        if !selectedSymptoms.isEmpty {
            print("Выбранные симптомы:")
            for (indexPath, isSelected) in selectedSymptoms {
                if isSelected {
                    let symptomTitle = getSymptomTitle(for: indexPath)
                    print("- \(symptomTitle) (секция: \(indexPath.section), элемент: \(indexPath.row))")
                }
            }
        } else {
            print("Симптомы не выбраны")
        }
        
        if !additionalSymptom.isEmpty {
            print("Дополнительная заметка: \(additionalSymptom)")
        } else {
            print("Дополнительная заметка отсутствует")
        }
        
        
        if !SymptomsManager.shared.contains(date: currentDate) && (!additionalSymptom.isEmpty || !selectedSymptoms.isEmpty)  {
            // save
            let symptomsModel = Symptoms(
                date: currentDate,
                symptoms: Array(selectedSymptoms.keys),
                note: additionalSymptom
            )
            
            SymptomsManager.shared.add(model: symptomsModel)
        } else if SymptomsManager.shared.contains(date: currentDate) && (!additionalSymptom.isEmpty || !selectedSymptoms.isEmpty)  {
            // update
            SymptomsManager.shared.update(
                date: currentDate,
                symptoms: Array(selectedSymptoms.keys),
                note: additionalSymptom
            )
        } else {
            // delete
            SymptomsManager.shared.remove(date: currentDate)
        }
        
        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(.success)
        }
        
        
        // Сохраняем пользовательские симптомы в UserDefaults
        saveUserSymptomsToUserDefaults()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.input.send(.dismiss)
        }
    }
    
    func load(date: Date) {
        let model = SymptomsManager.shared.get(date: date)
        retrieveSymptomModel = model
        
        additionalSymptom = model?.note ?? ""
        model?.symptoms.forEach{  indexPath in
            selectedSymptoms[indexPath] = true
        }
        
        
        // Загружаем пользовательские симптомы из UserDefaults
        loadUserSymptomsFromUserDefaults()
        
        // Обновляем отображение пользовательских симптомов
        updateDataSource()
    }
    
    // Вспомогательный метод для получения названия симптома по индексу
    private func getSymptomTitle(for indexPath: IndexPath) -> String {
        guard let dataSource = dataSource.value else { return "Неизвестный симптом" }
        
        switch indexPath.section {
        case 0: // symptoms
            if indexPath.row < dataSource.symptoms.count {
                return dataSource.symptoms[indexPath.row].title
            }
        case 1: // discharge
            if indexPath.row < dataSource.discharge.count {
                return dataSource.discharge[indexPath.row].title
            }
        case 2: // profuseBleeding
            if indexPath.row < dataSource.profuseBleeding.count {
                return dataSource.profuseBleeding[indexPath.row].title
            }
        case 3: // mySymptoms
            if indexPath.row < dataSource.mySymptoms.count {
                return dataSource.mySymptoms[indexPath.row].title
            }
        default:
            break
        }
        
        return "Неизвестный симптом"
    }
    
    // Метод для обновления пользовательских симптомов
    private func updateUserSymptoms(_ symptoms: [String]) {
        userSymptoms = symptoms
        updateDataSource()
    }
    
    // Метод для удаления пользовательского симптома
    private func removeUserSymptom(at indexPath: IndexPath) {
        guard indexPath.row < userSymptoms.count else { return }
        userSymptoms.remove(at: indexPath.row)
        updateDataSource()
        saveUserSymptomsToUserDefaults()
    }
    
    // Метод для сохранения пользовательских симптомов в UserDefaults
    private func saveUserSymptomsToUserDefaults() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateKey = dateFormatter.string(from: currentDate)
        UserDefaults.standard.set(userSymptoms, forKey: "user_symptoms_\(dateKey)")
    }
    
    // Метод для загрузки пользовательских симптомов из UserDefaults
    private func loadUserSymptomsFromUserDefaults() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateKey = dateFormatter.string(from: currentDate)
        let savedSymptoms = UserDefaults.standard.stringArray(forKey: "user_symptoms_\(dateKey)") ?? []
        userSymptoms = savedSymptoms
    }
}
