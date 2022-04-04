//
//  SyntaxTextStorage.swift
//  Syntax
//
//  Created by VladyslavMac on 19.02.2020.
//  Copyright © 2020 VladyslavMac. All rights reserved.


import UIKit

final class SyntaxTextStorage: NSTextStorage {
    
    final class ColorReplacement {
        var pattern: String
        var color: UIColor
        init(pattern: String, color: UIColor) {
            self.pattern = pattern
            self.color = color
        }
    }
    
    var allSymbols: [Symbol] = []
    
    var replacements: [ColorReplacement] = [
		.init(pattern: ".*", color: .label),
        .init(pattern: "SELECT|FROM|WHERE", color: UIColor(red: 100, green: 149, blue: 237)),
        .init(pattern: "int", color: .init(red: 196, green: 90, blue: 236)),
        .init(pattern: "f", color: .init(red: 153, green: 198, blue: 142)),
        .init(pattern: "\'.*?\'", color: .red),
        .init(pattern: "\".*?\"", color: .red),
		.init(pattern: #"--.*"#, color: .gray),
		.init(pattern: #"\/\*(.|\n)*?\\*/"#, color: .gray)
	]
    
    var backingString = NSMutableAttributedString()
    
    override var string: String {
    
        self.backingString.string
    }

    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        backingString.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        backingString.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: str.count - range.length)
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        backingString.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
    }
    
    func refreshPatterns() {
        let tokens = SymbolFactory.shared.tokenize(input: string)
        let keywords = tokens.filter({ $0.type == .keyword})
        if !keywords.isEmpty {
            replacements[1].pattern = keywords.map { "\\b\($0.value.lowercased())\\b" }.joined(separator: "|")
        }
        let types = tokens.filter({ $0.type == .datatype })
        if !types.isEmpty {
            replacements[2].pattern = types.map { "\\b\($0.value.lowercased())\\b" }.joined(separator: "|")
        }
        let symbols = tokens.filter({ $0.type == .unspecified })
        var functions: [String] = []
        for symbol in symbols {
            if SymbolFactory.shared.functions.contains(symbol.value) {
                functions.append(symbol.value)
            }
        }
        let functionsPattern = functions.map { "\\b\($0)\\b" }.joined(separator: "|")
        
        replacements[3].pattern = functionsPattern.isEmpty ? ">" : functionsPattern
    }
    
    override func processEditing() {
        
        refreshPatterns()

        do {
            var regex = NSRegularExpression()
            
            let ns = NSString(string: self.string)
            let rang = ns.paragraphRange(for: editedRange)
            self.removeAttribute(NSAttributedString.Key.foregroundColor, range: rang)

            for val in replacements.enumerated() {
                
                var options: NSRegularExpression.Options = []
                // if val.offset == 0 {
                
                    options.insert(NSRegularExpression.Options.caseInsensitive)
                // }
                
                regex = try NSRegularExpression(pattern: val.element.pattern, options: options)
                
				regex.enumerateMatches(in: self.string, options: [], range: rang) { (res, _, _) in
					if let res = res {
						addAttribute(NSAttributedString.Key.foregroundColor, value: val.element.color, range: res.range)
					}
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        super.processEditing()
        
    }    
    
}

