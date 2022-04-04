//
//  UserDefaultsKeys.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 30.01.2022.
//

import Foundation

/*
final class UserDefaultsKeys {
    
    private static let databasesListKey = "databasesListKey"
    static let shared = UserDefaultsKeys()
    
    func dropAll() {
        UserDefaults.standard.removeObject(forKey: Self.databasesListKey)
    }
    
    func addDatabase(name: String) {
        var dbList = UserDefaults.standard.object(forKey: Self.databasesListKey) as? [String] ?? []
        dbList.append(name)
        UserDefaults.standard.set(dbList, forKey: Self.databasesListKey)
    }
    
    func getDatabaseList() -> [String] {
        guard let dbList = UserDefaults.standard.object(forKey: Self.databasesListKey) as? [String] else { return [] }
        return dbList
    }
    
    func updateDatabaseName(oldName: String, newName: String) {}
    
    func dropDatabase(name: String) {
        guard var dbList = UserDefaults.standard.object(forKey: Self.databasesListKey) as? [String] else { return }
        dbList.removeAll { $0 == name }
        UserDefaults.standard.set(dbList, forKey: Self.databasesListKey)
    }
}
*/
