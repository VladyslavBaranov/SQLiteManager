//
//  SymbolContainer.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 05.02.2022.
//

import Foundation

enum SymbolType {
    case keyword, datatype, pragma, aggregateFunction, function,
         operatorSymbol, stringLiteral, semicolon, unspecified
}

struct Symbol {
    var value: String
    var type: SymbolType = .keyword
}

final class SymbolContainer {
    
    enum Extension: String {
        case json, txt
    }
    
    var symbolType: SymbolType = .keyword
    var pattern: String
    var symbols: [Symbol]
    
    init(fileName: String, fileExtension: Extension, symbolType: SymbolType) {
        let bundle = Bundle.main
        guard let file = bundle.url(forResource: fileName, withExtension: fileExtension.rawValue) else { fatalError() }
        guard let lines = try? String(contentsOf: file) else { fatalError() }
        pattern = ""
        
        let keys = lines.split(separator: "\n").map { String($0) }.map { $0.lowercased() }
        symbols = keys.map { .init(value: $0, type: symbolType) }

        // pattern = keys.map { "\\b\($0)\\b" }.joined()
        // print(pattern)
    }
}
