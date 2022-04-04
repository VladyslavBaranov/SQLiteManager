//
//  ScriptEntity+CoreDataProperties.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//
//

import Foundation
import CoreData


extension ScriptEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScriptEntity> {
        return NSFetchRequest<ScriptEntity>(entityName: "ScriptEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var scriptContent: String?
    @NSManaged public var dbName: String

}

extension ScriptEntity : Identifiable {

}
