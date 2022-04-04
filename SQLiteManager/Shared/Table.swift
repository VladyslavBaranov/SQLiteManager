//
//  Table.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 10.02.2022.
//

import Foundation

protocol TableInfoEntity {
    var name: String { get set }
    var sql: String { get set }
    var tableName: String { get set }
}

struct SingleNamedInfo: TableInfoEntity {
    var name: String = ""
    var sql: String = ""
    var tableName: String = ""
}

struct TableInfo: TableInfoEntity {
    
    var name: String = ""
    var sql: String = ""
    var tableName: String = ""
    var numberOfRows: Int = 0
    
    struct Field {
        var identifier: String
        var type: String
        var isPrimaryKey: Bool
        
        var isStringValue: Bool {
            let type = type.lowercased()
            return type.contains("text") || type.contains("date") || type.contains("char")
        }
    }
    var fields: [Field] = []
    init(rawPragmaRows: [[String]]) {
        if !rawPragmaRows.isEmpty {
            if let firstRow = rawPragmaRows.first {
                guard firstRow.count == 6 else { return }
                for row in rawPragmaRows {
                    let isPrimaryKey = row[5] == "1" ? true : false
                    let field = Field(identifier: row[1], type: row[2], isPrimaryKey: isPrimaryKey)
                    fields.append(field)
                }
            }
        }
    }
}
