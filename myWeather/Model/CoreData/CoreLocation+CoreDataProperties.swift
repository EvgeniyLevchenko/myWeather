//
//  CoreLocation+CoreDataProperties.swift
//  myWeather
//
//  Created by QwertY on 03.04.2022.
//
//

import Foundation
import CoreData


extension CoreLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreLocation> {
        return NSFetchRequest<CoreLocation>(entityName: "CoreLocation")
    }

    @NSManaged public var name: String?

}

extension CoreLocation : Identifiable {

}
