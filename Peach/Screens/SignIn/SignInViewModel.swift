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
                    self.userModel.value?.age = Int(text) ?? 0
                default:
                    break
                }
            case .fillFromBottomTF(let text):
                self.userModel.value?.cycle_duration = Int(text) ?? 0
            case .setDate(let date):
                self.userModel.value?.start_cycle_date = date
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
                input.send(.showAlert)
                return false
            } else {
                nextIndex += 1
                return true
            }
        case 2:
            if (userModel.value?.age == nil) {
                input.send(.showAlert)
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
