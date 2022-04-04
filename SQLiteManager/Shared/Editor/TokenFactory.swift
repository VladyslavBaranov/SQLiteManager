//
//  TokenFactory.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 08.02.2022.
//

import Foundation

struct SymbolFactory {
    
    static var shared = SymbolFactory()
    
    var sqlOperators: [String] = []
    var keywords: [String] = []
    var types: [String] = []
    var functions: [String] = []
    
    init() {
        let operators = SymbolContainer(fileName: "SQLiteOperators", fileExtension: .txt, symbolType: .operatorSymbol)
        sqlOperators = operators.symbols.map { $0.value }
        let keywords = SymbolContainer(fileName: "SQLiteKeywords", fileExtension: .txt, symbolType: .keyword)
        self.keywords = keywords.symbols.map { $0.value }
        let types = SymbolContainer(fileName: "SQLiteDataTypes", fileExtension: .txt, symbolType: .datatype)
        self.types = types.symbols.map { $0.value }
        let fs = SymbolContainer(fileName: "SQLiteFunctions", fileExtension: .txt, symbolType: .function)
        functions = fs.symbols.map { $0.value }
        print(operators)
    }
    
    func getToken(rawValue: String) -> Symbol {
        if keywords.contains(rawValue) {
            return Symbol(value: rawValue, type: .keyword)
        }
        if sqlOperators.contains(rawValue) {
            return Symbol(value: rawValue, type: .operatorSymbol)
        }
        if types.contains(rawValue) {
            return Symbol(value: rawValue, type: .datatype)
        }
        if rawValue.starts(with: "'") && rawValue.hasSuffix("'") {
            return Symbol(value: rawValue, type: .stringLiteral)
        }
        if rawValue.starts(with: "\"") && rawValue.hasSuffix("\"") {
            return Symbol(value: rawValue, type: .stringLiteral)
        }
        if rawValue == ";" {
            return Symbol(value: ";", type: .semicolon)
        }
        return Symbol(value: rawValue, type: .unspecified)
    }
    
    func tokenize(input: String) -> [Symbol] {
        let tokenizer = Tokenizer(input: input)
        let tokens = tokenizer.breakIntoTokens()
        return tokens.map { getToken(rawValue: $0) }
    }
}
