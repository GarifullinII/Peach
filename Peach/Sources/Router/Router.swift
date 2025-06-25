//
//  Router.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit

protocol Router: Presentable {
    func present(_ module: Presentable)

    func push(_ module: Presentable)
    func push(_ module: Presentable, hideBottomBar: Bool)
    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?)

    func dismissModule()
    func dismissModule(completion: @escaping () -> Void)

    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)
    func setRootModule(_ module: Presentable?, hideBottomBar: Bool)

    func popModule()
    func popToRootModule(animated: Bool)

    func presentSheet(_ module: Presentable)
}
