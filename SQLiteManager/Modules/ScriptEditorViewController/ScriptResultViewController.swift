//
//  ScriptResultViewController.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 05.02.2022.
//

import UIKit

final class ScriptResultViewController: UIViewController {
    
    var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    func displayResult() {
        textView.textColor = .label
        let columnNames = SQLiteResultTable.shared.names
        let rows = SQLiteResultTable.shared.getRows()
        
        let jsonTable = JSONTable(names: columnNames, rows: rows)
        let json = jsonTable.convertToJSON()
        
        textView.text = json
        // print(columnNames, rows)
        // if columnNames.isEmpty || rows.isEmpty {
        //     textView.text = "None"
        // } else {
        //     textView.text = ""
        //     textView.text.append(columnNames.joined(separator: ", "))
        //     textView.text.append("\n")
        //     for row in rows {
        //         textView.text.append(row.joined(separator: ", "))
        //         textView.text.append("\n")
        //     }
        // }
        SQLiteResultTable.shared.flush()
    }
    
    func displayError(error: String) {
        textView.text = error
        textView.textColor = .systemRed
    }
    
    func setupUI() {
        
        textView = UITextView()
        textView.text = "None"
        textView.textColor = .label
        textView.backgroundColor = .systemBackground
        textView.font = .monospacedSystemFont(ofSize: 20, weight: .medium)
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.isEditable = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
