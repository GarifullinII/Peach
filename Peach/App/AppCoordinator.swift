//
//  AppCoordinator.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit
import Combine

final class AppCoordinator: BaseCoordinator {

    // MARK: - Properties

    private let window: UIWindow

    private var cancellable: AnyCancellable?

    // MARK: - Initializers

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Instance methods

    override func start() {
        childCoordinators.forEach {
            removeDependency($0)
        }

        let isUserFirstLaunch = !UserDefaults.standard.bool(forKey: Config.userFirstLaunchKey.rawValue)
//        let isUserExist = UserDefaultsManager.shared.load(UserModel.self, Config.userModelKey.rawValue) != nil
        // Проверяем существование пользователя в CoreData
        print(">>DEBUG: AppCoordinator.start - проверяем существование пользователя в CoreData")
        let loadedUser = CoreDataManager.shared.loadUserModel()
        let isUserExist = loadedUser != nil
        
        print(">>DEBUG: AppCoordinator.start - isUserFirstLaunch: \(isUserFirstLaunch)")
        print(">>DEBUG: AppCoordinator.start - isUserExist: \(isUserExist)")
        
        if let user = loadedUser {
            print(">>DEBUG: AppCoordinator.start - найден пользователь: \(user.name ?? "без имени")")
        }

        if isUserFirstLaunch {
            print(">>DEBUG: AppCoordinator.start - показываем онбординг (первый запуск)")
            showOnboarding()
        } else {
            if isUserExist {
                print(">>DEBUG: AppCoordinator.start - показываем главный экран (пользователь существует)")
                showMain()
            } else {
                print(">>DEBUG: AppCoordinator.start - показываем экран входа (пользователь не найден)")
                showSignIn()
            }
        }
    }

    private func showMain() {
        let navigationController = UINavigationController()
        let router = RouterImpl(navigationController: navigationController)
        let coordinator = MainCoordinator(router: router)
        
        var retainedCoordinator: MainCoordinator? = coordinator

        cancellable = coordinator.output.sink { [weak self] output in
            guard let self else { return }

            switch output {
            case .dismiss:
                self.removeDependency(retainedCoordinator)
                retainedCoordinator = nil
                DispatchQueue.main.async {
                    self.showSignIn()
                }
            }
        }

        coordinator.start()
        addDependency(coordinator)
        window.rootViewController = navigationController
    }

    private func showOnboarding() {
        let navigationController = UINavigationController()
        let router = RouterImpl(navigationController: navigationController)
        let coordinator = OnboardingCoordinator(router: router)
        
        var retainedCoordinator: OnboardingCoordinator? = coordinator

        cancellable = coordinator.output.sink { [weak self] output in
            guard let self else { return }

            switch output {
            case .dismiss:
                self.removeDependency(retainedCoordinator)
                retainedCoordinator = nil
                DispatchQueue.main.async {
                    self.showMain()
                }
            }
        }

        coordinator.start()
        addDependency(coordinator)
        window.rootViewController = navigationController
    }

    private func showSignIn() {
        let navigationController = UINavigationController()
        let router = RouterImpl(navigationController: navigationController)
        let coordinator = SignInCoordinator(router: router)
        
        var retainedCoordinator: SignInCoordinator? = coordinator

        cancellable = coordinator.output.sink { [weak self] output in
            guard let self else { return }

            switch output {
            case .dismiss:
                self.removeDependency(retainedCoordinator)
                retainedCoordinator = nil
                DispatchQueue.main.async {
                    self.showMain()
                }
            }
        }

        coordinator.start()
        addDependency(coordinator)
        window.rootViewController = navigationController
    }
}
