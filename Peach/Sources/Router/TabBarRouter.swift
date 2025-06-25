//
//  TabBarRouter.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit

protocol TabBarRouter: Presentable {
    func setViewControllers(viewControllers: [UIViewController], animated: Bool)

    func present(_ module: Presentable?)
    func present(_ module: Presentable?, animated: Bool)

    func dismissModule()
    func dismissModule(animated: Bool, completion: (() -> Void)?)

    func changeRoot(to index: Int)
}
