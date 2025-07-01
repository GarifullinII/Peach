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
    
    private func bind() {
        input.sink { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .fillFromTopTF(let text, let index):
                switch index {
                case 0:
                    self.userModel.value?.name = text
                case 1:
                    // Обработка ввода возраста вручную (если пользователь вводит текст)
                    if let age = Int(text) {
                        self.userModel.value?.age = age
                    } else {
                        self.userModel.value?.age = nil
                    }
                default:
                    break
                }
                
            case .setDate(let date, let index):
                let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
                if index == 1 {
                    if age < 10 {
                        self.userModel.send(UserModel())
                        self.output.send(.showAgeAlert(
                            title: AssetString.warning.text,
                            message: AssetString.age_restriction.text
                        ))
                    } else {
                        var updatedUser = self.userModel.value ?? UserModel()
                        updatedUser.birthDate = date
                        updatedUser.age = age
                        self.userModel.send(updatedUser)
                    }
                } else if index == 2 {
                    var updatedUser = self.userModel.value ?? UserModel()
                    updatedUser.start_cycle_date = date
                    self.userModel.send(updatedUser)
                }
                
            case .fillFromBottomTF(let text):
                self.userModel.value?.cycle_duration = Int(text) ?? 0
                
            case .saveModel:
                self.saveUser(model: self.userModel.value) {
                    self.output.send(.dismiss)
                }
                
            case .showAlert:
                self.output.send(.showAlert)
            }
        }.store(in: &cancellables)
    }
    
    private func saveUser(model: UserModel?, completion: (() -> Void)) {
        UserDefaultsManager.shared.save(model, Config.userModelKey.rawValue)
        completion()
    }
    
    func checkFilling() -> Bool {
        switch nextIndex {
        case 1:
            if (userModel.value?.name ?? "").isEmpty {
                output.send(.showAlert)
                return false
            } else {
                nextIndex += 1
                return true
            }
        case 2:
            guard let age = userModel.value?.age else {
                output.send(.showInvalidAgeAlert)
                return false
            }
            
            if age < 10 {
                self.userModel.send(UserModel())
                output.send(.showAgeAlert(
                    title: AssetString.warning.text,
                    message: AssetString.age_restriction.text
                ))
                return false
            } else {
                nextIndex += 1
                return true
            }
        default:
            return false
        }
    }
}
