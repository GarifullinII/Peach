//
//  TabBarRouterImpl.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit

final class TabBarRouterImpl: TabBarRouter {

    // MARK: - Properties

    private weak var tabBarController: UITabBarController?

    // MARK: - Initializers

    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    // MARK: - Instance methods

    func toPresent() -> UIViewController? {
        tabBarController
    }

    func setViewControllers(viewControllers: [UIViewController], animated: Bool) {
        tabBarController?.setViewControllers(viewControllers, animated: true)
    }

    func present(_ module: Presentable?) {
        present(module, animated: true)
    }

    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else { return }
        if let presented = tabBarController?.topPresentedViewController {
            if presented is UIAlertController && controller is UIAlertController {
                return
            }
            presented.present(controller, animated: true, completion: nil)
        } else {
            tabBarController?.present(controller, animated: animated, completion: nil)
        }
    }

    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }

    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        if let presented = tabBarController?.topPresentedViewController {
            presented.dismiss(animated: animated, completion: completion)
        } else {
            tabBarController?.dismiss(animated: animated, completion: completion)
        }
    }
    
    func changeRoot(to index: Int) {
        tabBarController?.selectedIndex = index
    }
}

