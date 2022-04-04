//
//  SQLiteResultTable.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 30.01.2022.
//

import Foundation

struct SQLiteResultTable {
    static var shared = SQLiteResultTable()
    var values: [String] = []
    var names: [String] = []
    
    func getRows() -> [[String]] {
        guard names.count > 0 else { return [] }
        var rows: [[String]] = []
        let numberOfRows = values.count / names.count
        var offset = 0
        for _ in 0..<numberOfRows {
            var row: [String] = []
            for j in offset..<offset + names.count {
                row.append(values[j])
            }
            rows.append(row)
            offset += names.count
        }
        return rows
    }
    mutating func flush() {
        values.removeAll()
        names.removeAll()
    }
}
