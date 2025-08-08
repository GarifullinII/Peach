//
//  ProfileViewModel.swift
//  Peach
//
//  Created by Василий on 07.09.2023.
//

import Foundation
import Combine

protocol ProfileViewModel: AnyObject {
    var input: PassthroughSubject<ProfileInput, Never> { get }
    var output: PassthroughSubject<ProfileOutput, Never> { get }
}

final class ProfileViewModelImpl: BaseViewModel, ProfileViewModel {

    // MARK: - Properties

    var input = PassthroughSubject<ProfileInput, Never>()
    var output = PassthroughSubject<ProfileOutput, Never>()

    var userModel = CurrentValueSubject<UserModel?, Never>(nil)
    var profileCellModel = CurrentValueSubject<[ProfileCellModel], Never>([])
    var isSheetVisible = PassthroughSubject<Bool, Never>()

    // MARK: - Initializers

    override init() {
        super.init()

        bind()
        setup()
    }

    deinit {
        print("❌Deinit \(String(describing: self))")
    }

    // MARK: - Instance methods

    private func bind() {
        input.sink { [weak self] event in
            guard let self else { return }

            switch event {
            case .assistantTap:
                self.output.send(.showAssiatant)
            case .healthReportTap:
                self.output.send(.showHealthReport)
            case .premiumTap:
                self.output.send(.showPremium)
            case .signOut:
//                UserDefaultsManager.shared.remove(Config.userModelKey.rawValue)
                // Удаляем из CoreData
                CoreDataManager.shared.deleteUserModel()
                SymptomsManager.shared.clearUserData()
                SymptomsManager.shared.setCurrentUser(nil)
                self.output.send(.goToSetNameAndAge)
            }
        }.store(in: &cancellables)
    }

    private func setup() {
        profileCellModel.value = ProfileCellModel.model
//        userModel.value = UserDefaultsManager.shared.load(
//            UserModel.self,
//            Config.userModelKey.rawValue
//        )
        
        // Загружаем из CoreData
        print(">>DEBUG: ProfileViewModel - загружаем пользователя из CoreData")
        userModel.value = CoreDataManager.shared.loadUserModel()
        
        if let user = userModel.value {
            print(">>DEBUG: ProfileViewModel - пользователь успешно загружен: \(user.name ?? "без имени")")
        } else {
            print(">>DEBUG: ProfileViewModel - пользователь не найден в CoreData")
        }
    }
}
