//
//  File.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 29.01.2022.
//

import UIKit

protocol CollectionViewCellDelegate: AnyObject {
    func didTapInfoButton(for indexPath: IndexPath)
}

final class CollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CollectionViewCellDelegate!
    private let padding: CGFloat = 20
    
    var indexPath: IndexPath!
    var infoButton: UIButton!
    var imageView: UIImageView!
    
    var titleLabel: UILabel!
    var dateCreatedLabel: UILabel!
    var sizeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // backgroundColor = .systemGray5
        titleLabel.frame.origin = .init(x: padding, y: padding)
        infoButton.frame = .init(x: bounds.maxX - 30 - 10, y: 10, width: 30, height: 30)
        sizeLabel.frame.origin = .init(x: padding, y: bounds.maxY - sizeLabel.bounds.height - padding)
        
        let distanceBetweenNameAndSizeLables = sizeLabel.frame.minY - titleLabel.frame.maxY
        dateCreatedLabel.frame.origin.x = padding
        dateCreatedLabel.center.y = titleLabel.frame.maxY + distanceBetweenNameAndSizeLables / 2
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let previousTraitCollection = previousTraitCollection else {
            return
        }
        if previousTraitCollection.userInterfaceStyle != traitCollection.userInterfaceStyle {
            backgroundColor = RandomColorGenerator.getColor(interfaceStyle: traitCollection.userInterfaceStyle)
        }
    }
    func commonInit() {
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.text = "Sample Database"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .left
        
        infoButton = UIButton(type: .system)
        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        infoButton.tintColor = .systemYellow
        infoButton.addTarget(self, action: #selector(tapInfoButton), for: .touchUpInside)
        addSubview(infoButton)
        
        sizeLabel = UILabel()
        addSubview(sizeLabel)
        sizeLabel.text = "Size: 0 bytes"
        sizeLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        sizeLabel.textAlignment = .left
        sizeLabel.sizeToFit()
        
        dateCreatedLabel = UILabel()
        addSubview(dateCreatedLabel)
        dateCreatedLabel.text = "Created: \(Date().formatted())"
        dateCreatedLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        dateCreatedLabel.textAlignment = .left
        dateCreatedLabel.sizeToFit()
    }
    
    func set(dbName: String, date: Date, size: Int64) {
        titleLabel.text = dbName
        titleLabel.sizeToFit()
        
        dateCreatedLabel.text = "Created: \(date.formatted())"
        dateCreatedLabel.sizeToFit()
        
        sizeLabel.text = "Size: \(ByteCountFormatter.string(fromByteCount: size, countStyle: .binary))"
        sizeLabel.sizeToFit()
    }
    @objc func tapInfoButton() {
        if let indexPath = indexPath {
            delegate?.didTapInfoButton(for: indexPath)
        }
    }
}

