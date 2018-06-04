//
//  Destination+CoreDataProperties.swift
//  
//
//  Created by Mathieu Janneau on 16/04/2018.
//
//

import Foundation
import CoreData


extension Destination {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Destination> {
        return NSFetchRequest<Destination>(entityName: "Destination")
    }

    @NSManaged public var locationName: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double

}
