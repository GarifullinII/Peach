//
//  RouterImpl.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit
import BottomSheet

final class RouterImpl: Router {

    // MARK: - Properties

    private weak var navigationController: UINavigationController?

    // MARK: - Initializer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Instance methods

    func toPresent() -> UIViewController? {
        navigationController
    }

    func present(_ module: Presentable) {
        if let controller = module.toPresent() {
            navigationController?.present(controller, animated: true)
        }
    }

    func push(_ module: Presentable) {
        if let controller = module.toPresent() {
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    func push(_ module: Presentable, hideBottomBar: Bool) {
        if let controller = module.toPresent() {
            controller.hidesBottomBarWhenPushed = hideBottomBar
            navigationController?.pushViewController(controller, animated: true)
        }
    }

    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
        guard
            let controller = module?.toPresent(),
            controller is UINavigationController == false
        else {
            assertionFailure("Deprecated push UINavigationController.")
            return
        }

        guard controller !== navigationController?.topViewController else { return }

        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationController?.pushViewController(controller, animated: animated)
    }

    func setRootModule(_ module: Presentable?, hideBar: Bool? = false) {
        guard let controller = module?.toPresent() else { return }

        navigationController?.setViewControllers([controller], animated: false)

        if let hideBar = hideBar {
            navigationController?.isNavigationBarHidden = hideBar
        }
    }

    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }

    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }

        navigationController?.setViewControllers([controller], animated: false)
        navigationController?.isNavigationBarHidden = hideBar
    }

    func setRootModule(_ module: Presentable?, hideBottomBar: Bool = false) {
        guard let controller = module?.toPresent() else { return }

        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationController?.setViewControllers([controller], animated: false)
    }

    func popModule() {
        navigationController?.popViewController(animated: true)
    }

    func dismissModule() {
        navigationController?.dismiss(animated: true)
    }

    func dismissModule(completion: @escaping () -> Void) {
        navigationController?.dismiss(animated: true, completion: completion)
    }

    func popToRootModule(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }

    func presentSheet(_ module: Presentable) {
        navigationController?.presentBottomSheet(
            viewController: module.toPresent() ?? UIViewController(),
            configuration: .default,
            canBeDismissed: {
                true
            }
        )
    }
}
