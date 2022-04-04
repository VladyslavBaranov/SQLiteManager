//
//  TextFieldTableCell.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 30.01.2022.
//

import UIKit

protocol TextFieldTableCellDelegate: AnyObject {
    func textDidChange(_ text: String)
}

final class TextFieldTableCell: UITableViewCell {
    
    weak var delegate: TextFieldTableCellDelegate!
    var textField: UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.frame = bounds.insetBy(dx: bounds.midY * 0.8, dy: 0)
    }
    func setupUI() {
        textField = UITextField()
        textField.placeholder = "Database"
        textField.clearButtonMode = .always
        textField.isUserInteractionEnabled = true
        contentView.addSubview(textField)
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        delegate?.textDidChange(textField.text ?? "")
    }
}
