//
//  CoreDataManager.swift
//  Peach
//
//  Created by Ildar Garifullin on 07.08.2025.
//

import Foundation
import CoreData

// MARK: - Core Data Manager
public final class CoreDataManager {
    public static let shared = CoreDataManager()
    
    private let currentDatabaseVersionKey = "currentDatabaseVersion"
    private let currentDatabaseVersion = "1.0"
    
    private init() {}
    
    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PeachCD")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError(">>ERROR: Ошибка загрузки хранилища: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Database Migration
    func checkAndMigrateIfNeeded() {
        let savedVersion = UserDefaults.standard.string(forKey: currentDatabaseVersionKey)
        
        print(">>INFO: Текущая версия модели: \(currentDatabaseVersion)")
        print(">>INFO: Сохраненная версия модели: \(savedVersion ?? "нет данных")")
        
        // Если версия не совпадает, удаляем базу данных и пересоздаем
        if savedVersion != currentDatabaseVersion {
            print(">>INFO: Версии не совпадают. Удаляем базу данных и пересоздаем.")
            deleteDatabase()
            recreateDatabase()
            UserDefaults.standard.set(currentDatabaseVersion, forKey: currentDatabaseVersionKey)
            print(">>INFO: База данных пересоздана для версии \(currentDatabaseVersion)")
        } else {
            print(">>INFO: Версия базы данных актуальна: \(currentDatabaseVersion)")
        }
    }
    
    // MARK: - Database Management
    private func deleteDatabase() {
        guard let storeURL = persistentContainer.persistentStoreCoordinator.persistentStores.first?.url else {
            print(">>ERROR: Не удалось получить URL хранилища")
            return
        }
        
        print(">>INFO: Удаление базы данных по URL: \(storeURL)")
        
        do {
            try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
            print(">>INFO: База данных удалена")
        } catch {
            print(">>ERROR: Ошибка при удалении базы данных: \(error)")
        }
    }
    
    private func recreateDatabase() {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError(">>ERROR: Ошибка при пересоздании базы данных: \(error), \(error.userInfo)")
            }
            print(">>INFO: База данных пересоздана")
        }
    }
    
    // MARK: - Context Management
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Ошибка сохранения контекста: \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    // MARK: - UserModel Operations
        
        /// Сохранение одного UserModel в CoreData
    func saveUserModel(_ userModel: UserModel) {
        let context = persistentContainer.viewContext
        
        print(">>DEBUG: Начинаем сохранение UserModel в CoreData:")
        print("  - ID: \(userModel.id)")
        print("  - Имя: \(userModel.name ?? "nil")")
        print("  - Возраст: \(userModel.age?.description ?? "nil")")
        print("  - Дата рождения: \(userModel.birthDate?.description ?? "nil")")
        print("  - Дата начала цикла: \(userModel.startCycleDate?.description ?? "nil")")
        print("  - Длительность цикла: \(userModel.cycleDuration?.description ?? "nil")")
        
        // Проверяем, существует ли уже пользователь с таким ID
        let fetchRequest: NSFetchRequest<UserModelCD> = UserModelCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", userModel.id)
        
        do {
            let existingUsers = try context.fetch(fetchRequest)
            let userModelCD: UserModelCD
            
            if let existingUser = existingUsers.first {
                // Обновляем существующего пользователя
                print(">>DEBUG: Найден существующий пользователь с ID: \(userModel.id), обновляем данные")
                userModelCD = existingUser
            } else {
                // Создаем нового пользователя
                print(">>DEBUG: Создаем нового пользователя с ID: \(userModel.id)")
                userModelCD = UserModelCD(context: context)
                userModelCD.id = userModel.id
            }
            
            // Обновляем данные
            userModelCD.name = userModel.name
            userModelCD.age = userModel.age != nil ? NSNumber(value: userModel.age!) : nil
            userModelCD.birthDate = userModel.birthDate
            userModelCD.startCycleDate = userModel.startCycleDate
            userModelCD.cycleDuration = userModel.cycleDuration != nil ? NSNumber(value: userModel.cycleDuration!) : nil
            
            try context.save()
            print(">>INFO: UserModel успешно сохранен в Core Data!")
            print(">>DEBUG: Сохранение завершено успешно")
        } catch {
            print(">>ERROR: Не удалось сохранить UserModel в Core Data: \(error)")
        }
    }
        
        /// Загрузка UserModel из CoreData
    func loadUserModel() -> UserModel? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserModelCD> = UserModelCD.fetchRequest()
        
        print(">>DEBUG: Начинаем загрузку UserModel из CoreData")
        
        do {
            let userModelsCD = try context.fetch(fetchRequest)
            
            print(">>DEBUG: Найдено записей в CoreData: \(userModelsCD.count)")
            
            // Возвращаем первого найденного пользователя
            if let userModelCD = userModelsCD.first {
                let userModel = UserModel(
                    id: userModelCD.id,
                    name: userModelCD.name,
                    age: userModelCD.age?.intValue,
                    birthDate: userModelCD.birthDate,
                    startCycleDate: userModelCD.startCycleDate,
                    cycleDuration: userModelCD.cycleDuration?.intValue
                )
                
                print(">>DEBUG: Загружен UserModel из CoreData:")
                print("  - ID: \(userModel.id)")
                print("  - Имя: \(userModel.name ?? "nil")")
                print("  - Возраст: \(userModel.age?.description ?? "nil")")
                print("  - Дата рождения: \(userModel.birthDate?.description ?? "nil")")
                print("  - Дата начала цикла: \(userModel.startCycleDate?.description ?? "nil")")
                print("  - Длительность цикла: \(userModel.cycleDuration?.description ?? "nil")")
                
                return userModel
            } else {
                print(">>DEBUG: В CoreData не найдено ни одной записи UserModel")
            }
        } catch {
            print(">>ERROR: Не удалось загрузить UserModel из Core Data: \(error)")
        }
        
        print(">>DEBUG: Возвращаем nil - пользователь не найден")
        return nil
    }
        
        /// Удаление UserModel из CoreData
        func deleteUserModel() {
            let context = persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserModelCD.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                print(">>INFO: UserModel успешно удален из Core Data!")
            } catch {
                print(">>ERROR: Не удалось удалить UserModel из Core Data: \(error)")
            }
        }
//    // MARK: - Save UserModel
//    func saveUserModelToCoreData(_ userModels: [UserModel]) {
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UserModelCD.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        
//        do {
//            try context.execute(deleteRequest)
//        } catch {
//            print(">>ERROR: Не удалось очистить старые данные: \(error)")
//        }
//        
//        for userModel in userModels {
//            let userModelCD = UserModelCD(context: context)
//            userModelCD.id = userModel.id
//            userModelCD.name = userModel.name
//            userModelCD.age = userModel.age != nil ? NSNumber(value: userModel.age!) : nil
//            userModelCD.birthDate = userModel.birthDate
//            userModelCD.startCycleDate = userModel.startCycleDate
//            userModelCD.cycleDuration = userModel.cycleDuration != nil ? NSNumber(value: userModel.cycleDuration!) : nil
//        }
//        
//        do {
//            try context.save()
//            print(">>INFO: Данные успешно сохранены в Core Data!")
//        } catch {
//            print(">>ERROR: Не удалось сохранить данные в Core Data: \(error)")
//        }
}
