//
//  Objective+CoreDataProperties.swift
//  
//
//  Created by Mathieu Janneau on 16/04/2018.
//
//

import Foundation
import CoreData


extension Objective {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Objective> {
        return NSFetchRequest<Objective>(entityName: "Objective")
    }

    @NSManaged public var name: String?
    @NSManaged public var challenges: NSSet?

}

// MARK: Generated accessors for challenges
extension Objective {

    @objc(addChallengesObject:)
    @NSManaged public func addToChallenges(_ value: Challenge)

    @objc(removeChallengesObject:)
    @NSManaged public func removeFromChallenges(_ value: Challenge)

    @objc(addChallenges:)
    @NSManaged public func addToChallenges(_ values: NSSet)

    @objc(removeChallenges:)
    @NSManaged public func removeFromChallenges(_ values: NSSet)

}
