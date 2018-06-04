//
//  User+CoreDataProperties.swift
//  
//
//  Created by Mathieu Janneau on 16/04/2018.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var password: String?
    @NSManaged public var email: String?
    @NSManaged public var history: NSSet?
    @NSManaged public var objectives: NSSet?

}

// MARK: Generated accessors for history
extension User {

    @objc(addHistoryObject:)
    @NSManaged public func addToHistory(_ value: Mood)

    @objc(removeHistoryObject:)
    @NSManaged public func removeFromHistory(_ value: Mood)

    @objc(addHistory:)
    @NSManaged public func addToHistory(_ values: NSSet)

    @objc(removeHistory:)
    @NSManaged public func removeFromHistory(_ values: NSSet)

}

// MARK: Generated accessors for objectives
extension User {

    @objc(addObjectivesObject:)
    @NSManaged public func addToObjectives(_ value: Objective)

    @objc(removeObjectivesObject:)
    @NSManaged public func removeFromObjectives(_ value: Objective)

    @objc(addObjectives:)
    @NSManaged public func addToObjectives(_ values: NSSet)

    @objc(removeObjectives:)
    @NSManaged public func removeFromObjectives(_ values: NSSet)

}
