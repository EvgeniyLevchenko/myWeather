//
//  Locations+CoreDataProperties.swift
//  myWeather
//
//  Created by QwertY on 11.03.2022.
//
//

import Foundation
import CoreData


extension Locations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locations> {
        return NSFetchRequest<Locations>(entityName: "Locations")
    }

    @NSManaged public var name: String?

}

extension Locations : Identifiable {

}
