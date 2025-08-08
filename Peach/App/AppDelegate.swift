//
//  AppDelegate.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white

        let applicationCoordinator = AppCoordinator(window: window!)
        self.appCoordinator = applicationCoordinator

        window?.makeKeyAndVisible()

        // Инициализируем CoreData
        CoreDataManager.shared.checkAndMigrateIfNeeded()
        
        OpenAIManager.shared.setup()
        appCoordinator?.start()

        return true
    }
    
    
}
