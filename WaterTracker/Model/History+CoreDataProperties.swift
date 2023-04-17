//
//  History+CoreDataProperties.swift
//  WaterTracker
//
//  Created by Oscar lin on 4/17/23.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var date: String?
    @NSManaged public var volume: Double

}

extension History : Identifiable {

}
