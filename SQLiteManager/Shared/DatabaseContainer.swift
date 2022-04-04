//
//  DatabaseContainer.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//

import Foundation

final class DatabaseContainer {
    
    // var dbFile: DatabaseFile?
    
    /*
    init(dbEntity: DatabaseEntity) {
        self.dbEntity = dbEntity
        if let name = dbEntity.name {
            dbFile = DatabaseFile(name: name)
        }
    }
    
    private init(newEntity: DatabaseEntity) {
        self.dbEntity = newEntity
    }
    
    class func createNewDatabase(name: String) -> Result<DatabaseContainer, CoreDataManager.CoreDataError> {
        let res = CoreDataManager.shared.createDatabase(name: name)
        switch res {
        case .success(let newEntity):
            let fileResult = DatabaseFileManager.shared.createDatabase(name)
            switch fileResult {
            case .success(let file):
                let container = DatabaseContainer(newEntity: newEntity)
                container.dbFile = file
                return .success(container)
            case .failure(_):
                print("Could not create db file")
                return .failure(.common)
            }
        case .failure(_):
            print("Could not create entity")
            return .failure(.common)
        }
    }*/
    
}
