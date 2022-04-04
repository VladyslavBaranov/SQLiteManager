//
//  Tokenizer.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 08.02.2022.
//

import Foundation

struct Tokenizer {
    
    private let sqlOperators = ["+", "-", "*", "/", "%", "==", "=", "<>", ">", "<", ">=", "<=", "!<", "!>", ".", "&", "|", "~", "<<", ">>", ","]

    var input: String
    
    func breakIntoTokens() -> [String] {
        
        let input = input.replacingOccurrences(of: "\n", with: "", options: [], range: nil)
        
        var tokens: [String] = []
        var tempToken = ""
        var didEnterString = false
        for (index, char) in input.enumerated() {
            
            switch char {
            case " ":
                if didEnterString {
                    tempToken.append(char)
                } else {
                    if !tempToken.isEmpty {
                        tokens.append(tempToken.trimmingCharacters(in: .whitespaces))
                    }
                    tempToken = ""
                }
            case "(":
                if didEnterString {
                    tempToken.append(char)
                } else {
                    if !tempToken.isEmpty {
                        tokens.append(tempToken)
                        tempToken = ""
                    }
                    tokens.append("(")
                }
            case ")":
                if didEnterString {
                    tempToken.append(char)
                } else {
                    if !tempToken.isEmpty {
                        tokens.append(tempToken)
                        tempToken = ""
                    }
                    tokens.append(")")
                }
            case "'":
                tempToken.append("'")
                didEnterString.toggle()
            case ";":
                if didEnterString {
                    tempToken.append(char)
                } else {
                    if !tempToken.isEmpty {
                        tokens.append(tempToken)
                        tempToken = ""
                    }
                    tokens.append(";")
                }
            case let symbol where sqlOperators.contains(String(symbol)):
                if didEnterString {
                    tempToken.append(char)
                } else {
                    if !tempToken.isEmpty {
                        tokens.append(tempToken)
                        tempToken = ""
                    }
                    tokens.append(String(symbol))
                }
                
            default:
                tempToken.append(char)
            }
            
            if index == input.count - 1 {
                if !tempToken.isEmpty {
                    tokens.append(tempToken.trimmingCharacters(in: .whitespaces))
                }
            }
        }

        return tokens
    }
}
