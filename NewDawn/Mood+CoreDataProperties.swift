///**
/**
NewDawn
Created by: Mathieu Janneau on 16/04/2018
Copyright (c) 2018 Mathieu Janneau
*/
// swiftlint:disable trailing_whitespace
//

import Foundation
import CoreData


extension Mood {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mood> {
        return NSFetchRequest<Mood>(entityName: "Mood")
    }

    @NSManaged public var state: Int32
    @NSManaged public var date: Double
    @NSManaged public var user: User?

}
