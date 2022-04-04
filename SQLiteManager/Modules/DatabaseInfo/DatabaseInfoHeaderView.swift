//
//  DatabaseInfoHeaderView.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//

import UIKit

protocol DatabaseInfoHeaderViewDelegate: AnyObject {
    func didTapTrailingButton(section: Int)
}

final class DatabaseInfoHeaderView: UICollectionReusableView {
    
    enum TrailingItem {
        case writeScript, none
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }
    
    var trailingItemType: TrailingItem = .none {
        didSet {
            trailingButton.isHidden = trailingItemType == .none
        }
    }
    
    var section: Int = 0
    weak var delegate: DatabaseInfoHeaderViewDelegate?
    private var titleLabel: UILabel!
    var trailingButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel()
        titleLabel.text = "Scripts"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        
        trailingButton = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(scale: .large)
        trailingButton.setImage(.init(systemName: "square.and.pencil", withConfiguration: symbolConfig), for: .normal)
        addSubview(trailingButton)
        trailingButton.tintColor = .systemYellow
        trailingButton.addTarget(self, action: #selector(tapOnTrailingButton), for: .touchUpInside)
        trailingButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame.origin = .init(
            x: (bounds.maxY - titleLabel.bounds.height) / 2, y: bounds.maxY - titleLabel.bounds.height)
        trailingButton.frame = .init(x: bounds.maxX - bounds.maxY, y: 0, width: bounds.maxY, height: bounds.maxY)
    }
    @objc func tapOnTrailingButton() {
        delegate?.didTapTrailingButton(section: section)
    }
}
