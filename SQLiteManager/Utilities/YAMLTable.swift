//
//  YAMLTable.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 10.02.2022.
//

import Foundation

struct YAMLTable {
    private var names: [String]
    private var rows: [[String]]
    
    init(names: [String], rows: [[String]]) {
        self.names = names
        self.rows = rows
    }
    
    func convertToYAML() -> String {
        var yaml = ""
        
        for row in rows {
            for (i, name) in names.enumerated() {
                if i == 0 {
                    yaml.append("- \(name): \(row[i])\n")
                } else {
                    yaml.append("  \(name): \(row[i])\n")
                }
            }
        }
        return yaml
    }
}
