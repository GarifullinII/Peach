//
//  SignInViewModel.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import UIKit
import Combine

protocol SignInViewModel: AnyObject {
    var input: PassthroughSubject<SignInEvents, Never> { get }
    var output: PassthroughSubject<SignInOutput, Never> { get }
}

final class SignInViewModelImpl: BaseViewModel, SignInViewModel {
    
    // MARK: - Properties
    
    var input = PassthroughSubject<SignInEvents, Never>()
    var output = PassthroughSubject<SignInOutput, Never>()
    var signInModel = CurrentValueSubject<[SignInCellModel], Never>([])
    var userModel = CurrentValueSubject<UserModel?, Never>(UserModel())
    var nextIndex: Int = 1
    
    let buttonConstraintSize: CGFloat = 30.0
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        
        setup()
        bind()
    }
    
    deinit {
        print("❌Deinit:", String(describing: self))
    }
    
    
    // MARK: - Instance methods
    
    private func setup() {
        signInModel.value = SignInCellModel.signIn
        UserDefaults.standard.set(true, forKey: Config.userFirstLaunchKey.rawValue)
    }
    
    private func validateAge(_ age: Int?) -> Bool {
        guard let age = age, age >= 10 else {
            output.send(.showAgeAlert(
                title: AssetString.warning.text,
                message: AssetString.age_restriction.text
            ))
            return false
        }
        return true
    }
    
    private func bind() {
        input.sink { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .fillFromTopTF(let text, let index):
                switch index {
                case 0:
                    userModel.value?.name = text
                case 1:
                    if let age = Int(text), validateAge(age) {
                        userModel.value?.age = age
                    } else {
                        userModel.value?.age = nil
                    }
                default:
                    break
                }
            case .fillFromBottomTF(let text):
                if let duration = Int(text), duration >= 0, duration <= 50 {
                    userModel.value?.cycleDuration = duration
                } else {
                    userModel.value?.cycleDuration = nil
                    output.send(.showAlert)
                }
            case .setDate(let date, let index):
                //                let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
                
                // Вычисление возраста с учетом дня рождения
                let calendar = Calendar.current
                let now = Date()
                
                // Получаем компоненты даты рождения и текущей даты
                let birthComponents = calendar.dateComponents([.year, .month, .day], from: date)
                let nowComponents = calendar.dateComponents([.year, .month, .day], from: now)
                
                // Вычисляем возраст
                var age = (nowComponents.year ?? 0) - (birthComponents.year ?? 0)
                
                // Проверяем, прошел ли день рождения в этом году
                let birthMonth = birthComponents.month ?? 0
                let birthDay = birthComponents.day ?? 0
                let currentMonth = nowComponents.month ?? 0
                let currentDay = nowComponents.day ?? 0
                
                // Если день рождения еще не наступил в этом году, уменьшаем возраст на 1
                if currentMonth < birthMonth || (currentMonth == birthMonth && currentDay < birthDay) {
                    age -= 1
                }
                
                if index == 1 {
                    if validateAge(age) {
                        var updatedUser = userModel.value ?? UserModel()
                        updatedUser.birthDate = date
                        updatedUser.age = age
                        userModel.send(updatedUser)
                    } else {
                        //                        userModel.send(UserModel())
                        var updatedUser = userModel.value ?? UserModel()
                        updatedUser.birthDate = nil
                        updatedUser.age = nil
                        userModel.send(updatedUser)
                    }
                } else if index == 2 {
                    var updatedUser = userModel.value ?? UserModel()
                    updatedUser.startCycleDate = date
                    userModel.send(updatedUser)
                }
            case .saveModel:
                print("=== Проверка userModel перед сохранением ===")
                print("Имя: \(userModel.value?.name ?? "не указано")")
                print("Возраст: \(userModel.value?.age.map(String.init) ?? "не указан")")
                print("Дата рождения: \(userModel.value?.birthDate?.description ?? "не указана")")
                print("Дата цикла: \(userModel.value?.startCycleDate?.description ?? "не указана")")
                print("Длительность цикла: \(userModel.value?.cycleDuration.map(String.init) ?? "не указана")")
                print("==================================")
                
                if let user = userModel.value,
                   !(user.name?.isEmpty ?? true),
                   user.age != nil,
                   user.birthDate != nil,
                   user.startCycleDate != nil,
                   user.cycleDuration != nil {
                    saveUser(model: user) {
                        print("=== Сохраненные данные UserModel ===")
                        print("Имя: \(self.userModel.value?.name ?? "не указано")")
                        print("Возраст: \(self.userModel.value?.age.map(String.init) ?? "не указан")")
                        print("Дата рождения: \(self.userModel.value?.birthDate?.description ?? "не указана")")
                        print("Дата цикла: \(self.userModel.value?.startCycleDate?.description ?? "не указана")")
                        print("Длительность цикла: \(self.userModel.value?.cycleDuration ?? 0)")
                        print("==================================")
                        self.output.send(.dismiss)
                    }
                } else {
                    output.send(.showAlert)
                }
            case .showAlert:
                output.send(.showAlert)
            }
        }.store(in: &cancellables)
    }
    
    private func saveUser(model: UserModel?, completion: (() -> Void)) {
        //        UserDefaultsManager.shared.save(model, Config.userModelKey.rawValue)
        //        SymptomsManager.shared.setCurrentUser(model?.id)
        
        guard let model = model else {
            print(">>DEBUG: SignInViewModel.saveUser - модель пользователя nil, завершаем")
            completion()
            return
        }
        
        print(">>DEBUG: SignInViewModel.saveUser - сохраняем нового пользователя в CoreData:")
        print("  - Имя: \(model.name ?? "nil")")
        print("  - Возраст: \(model.age?.description ?? "nil")")
        print("  - Дата начала цикла: \(model.startCycleDate?.description ?? "nil")")
        
        // Сохраняем в CoreData вместо UserDefaults
        CoreDataManager.shared.saveUserModel(model)
        SymptomsManager.shared.setCurrentUser(model.id)
        print(">>DEBUG: SignInViewModel.saveUser - сохранение завершено")
        completion()
    }
    
    func checkFilling() -> Bool {
        switch nextIndex {
        case 1:
            if (userModel.value?.name ?? "").isEmpty {
                output.send(.showAlert)
                return false
            }
            nextIndex += 1
            return true
        case 2:
            guard let age = userModel.value?.age else {
                output.send(.showInvalidAgeAlert)
                return false
            }
            if validateAge(age) {
                nextIndex += 1
                return true
            }
            return false
        case 3:
            guard let startCycleDate = userModel.value?.startCycleDate,
                  let cycleDuration = userModel.value?.cycleDuration else {
                output.send(.showAlert)
                return false
            }
            return true
        default:
            return false
        }
    }
}
