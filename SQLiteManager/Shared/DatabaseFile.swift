//
//  DatabaseFile.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 30.01.2022.
//

import Foundation

class DatabaseFile {
    
    var dbName: String?
    var filePath: String
    var url: URL
    
    var sizeInBytes: Int64?
    var creationDate: Date?
    
    var tableCount: Int = 0
    
    var db: Database?
    
    init(filePath: String) {
        self.filePath = filePath
        url = URL(fileURLWithPath: filePath)
        
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: filePath) else { return }
        
        sizeInBytes = attributes[.size] as? Int64
        creationDate = attributes[.creationDate] as? Date
        
        db = Database(path: filePath)
    }
    
    init?(name: String) {
        let result = DatabaseFileManager.shared.getDatabaseURLWith(name: name)
        switch result {
        case .success(let url):
            self.filePath = url.path
            self.url = URL(fileURLWithPath: filePath)
            
            guard let attributes = try? FileManager.default.attributesOfItem(atPath: filePath) else { return }
            
            sizeInBytes = attributes[.size] as? Int64
            creationDate = attributes[.creationDate] as? Date
            
            dbName = name
            db = Database(path: filePath)
        case .failure(_):
            return nil
        }
    }
    
    class func createNewDatabase(name: String) -> Result<DatabaseFile, DatabaseFileManager.DatabaseFileError> {
        let result = DatabaseFileManager.shared.createDatabase(name)
        switch result {
        case .success(let file):
            return .success(file)
        case .failure(_):
            return .failure(.commonError)
        }
    }
    
    func reloadSize() {
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: filePath) else { return }
        sizeInBytes = attributes[.size] as? Int64
    }
}
