//
//  DatabaseInfoCollectionViewCell.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//

import UIKit

final class DatabaseInfoCollectionViewCell: UICollectionViewCell {
    
    enum Mode {
        case title, titleTwoValues
    }
    var mode: Mode = .title
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }
    var value1: String = "" {
        didSet {
            value1Label.text = value1
            value1Label.sizeToFit()
        }
    }
    var value2: String = "" {
        didSet {
            value2Label.text = value2
            value2Label.sizeToFit()
        }
    }
    private var titleLabel: UILabel!
    private var value1Label: UILabel!
    private var value2Label: UILabel!
    private let padding: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if mode == .titleTwoValues {
            value2Label.isHidden = false
            value1Label.isHidden = false
            
            titleLabel.frame.origin = .init(x: padding, y: padding)
            // infoButton.frame = .init(x: bounds.maxX - 30 - 10, y: 10, width: 30, height: 30)
            value2Label.frame.origin = .init(x: padding, y: bounds.maxY - value2Label.bounds.height - padding)
            
            let distanceBetweenNameAndSizeLables = value2Label.frame.minY - titleLabel.frame.maxY
            value1Label.frame.origin.x = padding
            value1Label.center.y = titleLabel.frame.maxY + distanceBetweenNameAndSizeLables / 2
        } else {
            value2Label.isHidden = true
            value1Label.isHidden = true
            titleLabel.frame = .init(x: padding, y: 0, width: bounds.width - 2 * padding, height: bounds.height)
        }
    }
    
    func setDefaultContent() {
        titleLabel.text = "--"
        value2Label.text = "Number of columns: --"
        value1Label.text = "Created: --"
    }
    
    private func commonInit() {
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.text = "--" // "Sample Database"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        
        // infoButton = UIButton(type: .system)
        // infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        // infoButton.tintColor = .systemYellow
        // infoButton.addTarget(self, action: #selector(tapInfoButton), for: .touchUpInside)
        // addSubview(infoButton)
        
        value2Label = UILabel()
        value2Label.textColor = .lightGray
        addSubview(value2Label)
        value2Label.text = "Number of columns: --" // "0 bytes"
        value2Label.font = .systemFont(ofSize: 16, weight: .semibold)
        value2Label.textAlignment = .left
        value2Label.sizeToFit()
        
        value1Label = UILabel()
        value1Label.textColor = .lightGray
        addSubview(value1Label)
        value1Label.text = "Created: --" // " \(Date().formatted())"
        value1Label.font = .systemFont(ofSize: 16, weight: .semibold)
        value1Label.textAlignment = .left
        value1Label.sizeToFit()
    }
}
