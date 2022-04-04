//
//  SwitchTableCell.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 30.01.2022.
//

import UIKit

protocol SwitchTableCellDelegate: AnyObject {
    func toggleDidChange(_ isOn: Bool)
}

final class SwitchTableCell: UITableViewCell {
    
    weak var delegate: SwitchTableCellDelegate!
    var switchControl: UISwitch!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setupUI() {
        switchControl = UISwitch()
        switchControl.onTintColor = .systemYellow
        switchControl.addTarget(self, action: #selector(toggleDidChangeValue(_:)), for: .valueChanged)
        accessoryView = switchControl
    }
    @objc func toggleDidChangeValue(_ sender: UISwitch) {
        delegate?.toggleDidChange(sender.isOn)
    }
}
