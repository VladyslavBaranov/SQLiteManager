//
//  Database.swift
//  SqliteTest
//
//  Created by Vladyslav Baranov on 29.01.2022.
//

import Foundation
import SQLite3

func callBack(
    _ udp: UnsafeMutableRawPointer?,
    c_num: Int32,
    c_vals: UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?,
    c_names:  UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?
) -> Int32 {
    guard let v_ptr = c_vals else { return 1 }
    for i in 0..<c_num {
        if let cString = v_ptr[Int(i)] {
            let str = String(cString: cString)
            SQLiteResultTable.shared.values.append(str)
        } else {
            SQLiteResultTable.shared.values.append("NULL")
        }
    }
    if SQLiteResultTable.shared.names.count < c_num {
        guard let c_ptr = c_names else { return 1 }
        for i in 0..<c_num {
            if let cString = c_ptr[Int(i)] {
                let str = String(cString: cString)
                SQLiteResultTable.shared.names.append(str)
            }
        }
    }
    return 0
}

class Database {
    
    struct NameSQL {
        var name: String
        var tableName: String
        var sql: String
    }
    
    enum QueryError: Error {
        case common(String)
    }
    
    private var path: String
    private var connection: OpaquePointer?
    
    init(path: String) {
        self.path = path
    }
    
    func open() {
        if sqlite3_open(path, &connection) != SQLITE_OK {
            return
        }
    }
    
    func close() {
        sqlite3_close(connection)
    }
    
    func execute(sql: String) -> Result<Bool, QueryError> {
        var errMsg: UnsafeMutablePointer<CChar>?
        if sqlite3_exec(connection, sql, callBack, nil, &errMsg) != SQLITE_OK {
            if let err = errMsg {
                let str = String(cString: err)
                return .failure(.common(str))
            } else {
                return .success(true)
            }
        }
        return .success(true)
    }
    
    func fetchTables() -> [TableInfo] {
        var tables: [TableInfo] = []
        
        let tableNameSQLObjects = fetchNameSQLFromMasterEntities(type: "table")
        
        for object in tableNameSQLObjects {
            
            _ = execute(sql: "PRAGMA table_info('\(object.name)')")
            let rawRows = SQLiteResultTable.shared.getRows()
            SQLiteResultTable.shared.flush()
            
            var table = TableInfo(rawPragmaRows: rawRows)
            table.tableName = object.tableName
            table.name = object.name
            table.sql = object.sql
            table.numberOfRows = getNumberOfRowsIn(table: table.name)
            
            tables.append(table)
        }
        return tables
    }
    
    func fetchEntities(type: String) -> [SingleNamedInfo] {
        var entities: [SingleNamedInfo] = []
        let tableNameSQLObjects = fetchNameSQLFromMasterEntities(type: type)
        for object in tableNameSQLObjects {
            var entity = SingleNamedInfo()
            entity.tableName = object.tableName
            entity.sql = object.sql
            entity.name = object.name
            entities.append(entity)
        }
        return entities
    }
    
    func fetchNameSQLFromMasterEntities(type: String) -> [NameSQL] {
        _ = execute(sql: "SELECT name, tbl_name, sql from sqlite_master WHERE type ='\(type)'")
        let rows = SQLiteResultTable.shared.getRows()
        var objects: [NameSQL] = []
        for row in rows {
            if row.count == 3 {
                objects.append(.init(name: row[0], tableName: row[1], sql: row[2]))
            }
        }
        SQLiteResultTable.shared.flush()
        return objects
    }
    
    private func getNumberOfRowsIn(table: String) -> Int {
        _ = execute(sql: "SELECT COUNT(*) FROM \(table)")
        guard let firstArr = SQLiteResultTable.shared.getRows().first else {
            SQLiteResultTable.shared.flush()
            return -1
        }
        guard let first = firstArr.first else {
            SQLiteResultTable.shared.flush()
            return -1
        }
        SQLiteResultTable.shared.flush()
        return Int(first) ?? -1
    }
}
