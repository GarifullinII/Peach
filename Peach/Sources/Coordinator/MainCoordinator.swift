//
//  MainCoordinator.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit
import Combine

final class MainCoordinator: BaseCoordinator {

    // MARK: - Nested types

    enum Output {
        case dismiss
    }

    // MARK: - Properties

    private typealias Flow = (Coordinator, UINavigationController)

    var output = PassthroughSubject<Output, Never>()

    private var cancellables = Set<AnyCancellable>()

    private let router: Router

    private let tabBarController = UITabBarController()

    // MARK: - Initializers

    init(router: Router) {
        self.router = router
    }

    deinit {
        print("❌Deinit \(String(describing: self))")
    }

    // MARK: - Instance methods

    override func start() {
        let tabBarRouter = TabBarRouterImpl(tabBarController: tabBarController)
        let flows = [calendarSwiftUIFlow(), chatFlow(), profileFlow()]
        let controllers = flows.map { $0.1 }
        let coordinators = flows.map { $0.0 }

        coordinators.forEach {
            addDependency($0)
            $0.start()
        }

        tabBarRouter.setViewControllers(viewControllers: controllers, animated: true)

        UITabBar.appearance().tintColor = .mainPink
        UITabBar.appearance().backgroundColor = .tabBarGray
        UITabBar.appearance().itemPositioning = .automatic

        tabBarController.tabBar.unselectedItemTintColor = .black
        tabBarController.tabBar.backgroundImage = UIImage()
        router.push(tabBarController)
    }
}

extension MainCoordinator {

    // MARK: - Instance methods

    private func calendarSwiftUIFlow() -> Flow {
        let navigationController = navigationController(
            title: AssetString.calendar.text,
            image: AssetImage.calendar.image,
            selectImage: AssetImage.сalendar_selected.image
        )
        let router = RouterImpl(navigationController: navigationController)
        let coordinator = CalendarCoordinator(router: router)

        coordinator.output.sink { [weak self] output in
            self?.tabBarController.tabBar.isHidden = output
        }.store(in: &cancellables)

        return (coordinator, navigationController)
    }

    private func chatFlow() -> Flow {
        let navigationController = navigationController(
            title: AssetString.assistant.text,
            image: AssetImage.chat.image,
            selectImage: AssetImage.chat_selected.image
        )

        let router = RouterImpl(navigationController: navigationController)
        let tabBarRouter = TabBarRouterImpl(tabBarController: tabBarController)
        let coordinator = ChatCoordinator(router: router, tabBarRouter: tabBarRouter)

        return (coordinator, navigationController)
    }

    private func profileFlow() -> Flow {
        let navigationController = navigationController(
            title: AssetString.profile.text,
            image: AssetImage.profile.image,
            selectImage: AssetImage.profile.image
        )
        let router = RouterImpl(navigationController: navigationController)
        let coordinator = ProfileCoordinator(router: router)

        coordinator.output.sink { [weak self] output in
            switch output {
            case .dismiss:
                self?.output.send(.dismiss)
            }
        }.store(in: &cancellables)

        return (coordinator, navigationController)
    }

    private func navigationController(
        title: String,
        image: UIImage,
        selectImage: UIImage
    ) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.title = title
        navigationController.tabBarItem.image = image.withRenderingMode(.alwaysOriginal)
        navigationController.tabBarItem.selectedImage = selectImage.withRenderingMode(.alwaysOriginal)
        return navigationController
    }
}
