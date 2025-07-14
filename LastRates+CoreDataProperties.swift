//
//  LastRates+CoreDataProperties.swift
//  CCC
//
//  Created by luca on 7/14/25.
//
//

import Foundation
import CoreData


extension LastRates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastRates> {
        return NSFetchRequest<LastRates>(entityName: "LastRates")
    }

    @NSManaged public var date: String?
    @NSManaged public var ratesData: Data?

}

extension LastRates : Identifiable {

}
