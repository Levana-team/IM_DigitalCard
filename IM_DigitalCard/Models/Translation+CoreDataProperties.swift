//
//  Translation+CoreDataProperties.swift
//  
//
//  Created by elie buff on 29/12/2020.
//
//

import Foundation
import CoreData


extension Translation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Translation> {
        return NSFetchRequest<Translation>(entityName: "Translation")
    }

    @NSManaged public var en: String?
    @NSManaged public var fr: String?
    @NSManaged public var label: String?

}
