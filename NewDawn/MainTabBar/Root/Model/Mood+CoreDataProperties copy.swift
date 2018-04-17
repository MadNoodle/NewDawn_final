//
//  Mood+CoreDataProperties.swift
//  
//
//  Created by Mathieu Janneau on 16/04/2018.
//
//

import Foundation
import CoreData


extension Mood {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mood> {
        return NSFetchRequest<Mood>(entityName: "Mood")
    }

    @NSManaged public var state: Int32
    @NSManaged public var date: Double

}
