//
//  JSONTable.swift
//  SqliteTest
//
//  Created by Vladyslav Baranov on 10.02.2022.
//

import Foundation

struct JSONTable {
    
    private var names: [String]
    private var rows: [[String]]
    private var nameIsStringArray: [Bool] = []
    
    init(names: [String], rows: [[String]]) {
        self.names = names
        self.rows = rows
        if let firstRow = rows.first {
            for value in firstRow {
                let doubleValue = Double(value)
                nameIsStringArray.append(doubleValue == nil)
            }
        }
    }
    
    func convertToJSON() -> String {
        var json = "[\n"
        
        for (id, row) in rows.enumerated() {
            var obj = "\t{"
            for (i, name) in names.enumerated() {
                obj.append("\n\t\t\"\(name)\": ")
                if nameIsStringArray[i] {
                    obj.append("\"\(row[i])\"")
                } else {
                    obj.append("\(row[i])")
                }
                if i < names.count - 1 {
                    obj.append(",")
                }
            }
            if id < rows.count - 1 {
                obj.append("\n\t},\n")
            } else {
                obj.append("\n\t}\n")
            }
            
            json.append(obj)
        }
        json.append("]")
        return json
    }
}
