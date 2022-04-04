//
//  CoreDataManager.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//

import CoreData
import UIKit

final class CoreDataManager {
    
    enum CoreDataError: Error {
        case common
    }
    
    static let shared = CoreDataManager()
    private var context: NSManagedObjectContext
    
    private init() {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { fatalError() }
        self.context = appDelegate.persistentContainer.viewContext
    }
    /*
    func createDatabase(name: String) -> Result<DatabaseEntity, CoreDataError> {
        let res = getDatabase(name: name)
        switch res {
        case .success(let db):
            if db == nil {
                let db = DatabaseEntity(context: context)
                db.name = name
                try? context.save()
                return .success(db)
            } else {
                return .failure(.common)
                print("Entity already exists")
            }
        case .failure(_):
            return .failure(.common)
            print("Could not fetch enities")
        }
    }
    func getDatabases() -> Result<[DatabaseEntity], CoreDataError> {
        let request = NSFetchRequest<DatabaseEntity>(entityName: "DatabaseEntity")
        do {
            let res = try context.fetch(request)
            return .success(res)
        } catch {
            return .failure(.common)
        }
    }
    func getDatabase(name: String) -> Result<DatabaseEntity?, CoreDataError> {
        let request = NSFetchRequest<DatabaseEntity>(entityName: "DatabaseEntity")
        request.predicate = NSPredicate(format: "name = %@", name)
        do {
            let res = try context.fetch(request)
            if res.isEmpty {
                return .success(nil)
            } else {
                if res.count == 1 {
                    return .success(res[0])
                }
                return .failure(.common)
            }
        } catch {
            return .failure(.common)
        }
    }*/
}

extension CoreDataManager {
    func deleteAllDbs() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DatabaseEntity")
        let deleteReq = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteReq)
            print("DELETED")
        } catch {
            print("ERROR")
        }
    }
}
