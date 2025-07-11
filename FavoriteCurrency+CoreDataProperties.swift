//
//  FavoriteCurrency+CoreDataProperties.swift
//  CCC
//
//  Created by luca on 7/10/25.
//
//

import Foundation
import CoreData


extension FavoriteCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCurrency> {
        return NSFetchRequest<FavoriteCurrency>(entityName: "FavoriteCurrency")
    }

    @NSManaged public var code: String?

}

extension FavoriteCurrency : Identifiable {

}
