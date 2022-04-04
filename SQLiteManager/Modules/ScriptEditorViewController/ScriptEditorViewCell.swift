//
//  ScriptEditorViewCell.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 05.02.2022.
//

import UIKit

final class ScriptEditorViewCell: UICollectionViewCell {
    
    var symbol: Symbol! {
        didSet {
            if symbol != nil {
                label.text = symbol.value.uppercased()
                setupFor(symbolType: symbol.type)
            }
        }
    }
    var label: UILabel!
    var symbolTypeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel()
        label.text = Array(repeating: "Key", count: Int.random(in: 3...8)).joined()
        label.font = .monospacedSystemFont(ofSize: 16, weight: .medium)
        label.sizeToFit()
        label.backgroundColor = .systemGray6
        contentView.addSubview(label)
        label.textColor = .label
        backgroundColor = .systemGray6
        
        symbolTypeLabel = UILabel()
        symbolTypeLabel.font = .systemFont(ofSize: 14)
        symbolTypeLabel.clipsToBounds = true
        symbolTypeLabel.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
        symbolTypeLabel.textAlignment = .center
        addSubview(symbolTypeLabel)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds.insetBy(dx: 8, dy: 0)
        symbolTypeLabel.center = .init(x: bounds.maxX - symbolTypeLabel.bounds.width / 2 - 4, y: bounds.midY)
        symbolTypeLabel.layer.cornerRadius = symbolTypeLabel.bounds.height / 2
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if let symbol = symbol {
            setupFor(symbolType: symbol.type)
        }
    }
    func estimatedWidth() -> CGFloat {
        label.bounds.width + symbolTypeLabel.bounds.width + 24
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFor(symbolType: SymbolType) {
        switch symbolType {
        case .keyword:
            symbolTypeLabel.text = "KEYWORD"
            if traitCollection.userInterfaceStyle == .light {
                symbolTypeLabel.backgroundColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
                symbolTypeLabel.textColor = .red
            } else {
                symbolTypeLabel.backgroundColor = .red
                symbolTypeLabel.textColor = UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1)
            }
        case .datatype:
            if traitCollection.userInterfaceStyle == .light {
                symbolTypeLabel.backgroundColor = UIColor(red: 0.7, green: 0.9, blue: 0.7, alpha: 1)
                symbolTypeLabel.textColor = UIColor(red: 0.5, green: 0.6, blue: 0.5, alpha: 1)
            } else {
                symbolTypeLabel.backgroundColor = UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1)
                symbolTypeLabel.textColor = UIColor(red: 0.7, green: 1, blue: 0.7, alpha: 1)
            }
            symbolTypeLabel.text = "DATATYPE"
        case .pragma:
            break
        case .aggregateFunction:
            break
        case .function:
            if traitCollection.userInterfaceStyle == .light {
                symbolTypeLabel.backgroundColor = UIColor(red: 191, green: 209, blue: 229)
                symbolTypeLabel.textColor = UIColor(red: 72, green: 120, blue: 170)
            } else {
                symbolTypeLabel.backgroundColor = UIColor(red: 51, green: 171, blue: 249)
                symbolTypeLabel.textColor = UIColor(red: 191, green: 209, blue: 229)
            }
            symbolTypeLabel.text = "FUNCTION"
        default:
            break
        }
        symbolTypeLabel.sizeToFit()
        symbolTypeLabel.frame.size.width += 20
        symbolTypeLabel.frame.size.height += 5
    }
}
