//
//  UserModelCD+CoreDataProperties.swift
//  Peach
//
//  Created by Ildar Garifullin on 06.08.2025.
//
//

import Foundation
import CoreData


extension UserModelCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserModelCD> {
        return NSFetchRequest<UserModelCD>(entityName: "UserModelCD")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String?
    @NSManaged public var age: NSNumber?
    @NSManaged public var birthDate: Date?
    @NSManaged public var startCycleDate: Date?
    @NSManaged public var cycleDuration: NSNumber?

}

extension UserModelCD : Identifiable {

}
