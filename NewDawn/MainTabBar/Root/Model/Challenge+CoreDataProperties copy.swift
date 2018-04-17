//
//  Challenge+CoreDataProperties.swift
//  
//
//  Created by Mathieu Janneau on 16/04/2018.
//
//

import Foundation
import CoreData


extension Challenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Challenge> {
        return NSFetchRequest<Challenge>(entityName: "Challenge")
    }

    @NSManaged public var name: String?
    @NSManaged public var dueDate: Double
    @NSManaged public var isDone: Bool
    @NSManaged public var isSuccess: Bool
    @NSManaged public var isNotified: Bool
    @NSManaged public var anxietyLevel: Int32
    @NSManaged public var benefitLevel: Int32
    @NSManaged public var felt: Int32
    @NSManaged public var comment: String?
    @NSManaged public var map: NSData?
    @NSManaged public var destination: Destination?

}
