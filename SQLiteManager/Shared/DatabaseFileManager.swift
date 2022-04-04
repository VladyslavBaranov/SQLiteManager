//
//  DatabaseFileManager.swift
//  SqliteTest
//
//  Created by Vladyslav Baranov on 29.01.2022.
//

import Foundation

final class DatabaseFileManager {
    
    static let shared = DatabaseFileManager()
    
    enum DatabaseFileError: Error {
        case databaseAlreadyExists(String)
        case databaseNotExists(String)
        case commonError
    }
    
    func getDatabaseURLWith(name: String) -> Result<URL, DatabaseFileError> {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return .failure(.commonError)
        }
        let dbUrl = url.appendingPathComponent(name).appendingPathExtension("sqlite")
        let manager = FileManager.default
        guard manager.fileExists(atPath: dbUrl.path) else {
            return .failure(.databaseNotExists(name))
        }
        return .success(dbUrl)
    }
    
    func createDatabase(_ name: String) -> Result<DatabaseFile, DatabaseFileError> {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("No such a directory")
            return .failure(.commonError)
        }
        let dbUrl = url.appendingPathComponent(name).appendingPathExtension("sqlite")
        let manager = FileManager.default
        
        if !manager.fileExists(atPath: dbUrl.path) {
            manager.createFile(atPath: dbUrl.path, contents: nil, attributes: [:])
            let dbFile = DatabaseFile(filePath: dbUrl.path)
            return .success(dbFile)
        } else {
            print("FILE EXISTS")
            return .failure(.databaseAlreadyExists(name))
        }
    }
    
    func dropDatabase(_ name: String) -> Result<String, DatabaseFileError> {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return .failure(.commonError)
        }
        let dbUrl = url.appendingPathComponent(name).appendingPathExtension("sqlite")
        let manager = FileManager.default
        if manager.fileExists(atPath: dbUrl.path) {
            do {
                try manager.removeItem(at: dbUrl)
                return .success(name)
            } catch {
                return .failure(.commonError)
            }
        } else {
            return .failure(.databaseNotExists(name))
        }
    }
    func getDatabaseNames() -> Result<[String], DatabaseFileError> {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return .failure(.commonError) }
        guard let urls = try? FileManager.default.contentsOfDirectory(atPath: url.path) else {
            return .failure(.commonError)
        }
        var names: [String] = []
        for file in urls {
            if let fileName = file.split(separator: ".").first {
                names.append(String(fileName))
            }
        }
        return .success(names)
    }
    func deleteSQLiteFiles() {
        guard let urlG = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        guard let urls = try? FileManager.default.contentsOfDirectory(atPath: urlG.path) else { return }
        for url in urls {
            if url.contains("sqlite") {
                try? FileManager.default.removeItem(at: urlG.appendingPathComponent(url))
            }
        }
    }
}
