//
//  LastScreen+CoreDataProperties.swift
//  CCC
//
//  Created by luca on 7/12/25.
//
//

import Foundation
import CoreData


extension LastScreen {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastScreen> {
        return NSFetchRequest<LastScreen>(entityName: "LastScreen")
    }

    @NSManaged public var screen: String?
    @NSManaged public var param: String?

}

extension LastScreen : Identifiable {

}
