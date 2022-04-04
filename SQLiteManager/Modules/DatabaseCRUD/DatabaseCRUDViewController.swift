//
//  DatabaseCRUDViewController.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 29.01.2022.
//

import UIKit
import UniformTypeIdentifiers

struct DatabaseCRUDItem {
    
    enum CellType {
        case plain, textField, switchControl
    }
    enum Action {
        case delete, setPasscode, export, none
    }
    var title: String
    var value: String
    var cellType: CellType
    var action: Action = .none
}

struct DatabaseCRUDSection {
    var title: String
    var items: [DatabaseCRUDItem]
    var footerTitle: String?
}

protocol DatabaseCRUDViewControllerDelegate: AnyObject {
    func databaseCreated(name: String)
    func didDeleteDatabase(name: String)
}

final class DatabaseCRUDViewController: UITableViewController {
    
    enum Mode {
        case create
        case edit
    }
    
    var dbFile: DatabaseFile?
    var mode: Mode = .create
    
    var sections: [DatabaseCRUDSection] = [
        .init(title: "Name", items: [.init(title: "", value: "", cellType: .textField)], footerTitle: nil),
        .init(title: "", items: [.init(title: "Use sample database", value: "", cellType: .switchControl)], footerTitle: "If this option is selected database with sample tables will be created"),
        .init(title: "", items: [.init(title: "Turn Passcode On", value: "", cellType: .plain)], footerTitle: "This In-App passcode allows you to block specific database on opening")
    ]
    
    weak var delegate: DatabaseCRUDViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit database"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "plainId")
        tableView.register(TextFieldTableCell.self, forCellReuseIdentifier: "textFieldId")
        tableView.register(SwitchTableCell.self, forCellReuseIdentifier: "switchId")
        setupUI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = sections[indexPath.section].items[indexPath.row]
        switch item.cellType {
        case .textField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldId", for: indexPath) as! TextFieldTableCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .switchControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: "switchId", for: indexPath) as! SwitchTableCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.textLabel?.text = item.title
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "plainId", for: indexPath)
            cell.textLabel?.text = item.title
            switch item.action {
            case .delete:
                cell.textLabel?.textColor = .systemRed
            case .setPasscode:
                cell.textLabel?.textColor = .systemBlue
            default:
                break
            }
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sections[section].footerTitle
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.row]
        if mode == .edit {
            if item.action == .delete {
                if let dbFile = dbFile, let dbName = dbFile.dbName {
                    deleteDatabase(name: dbName)
                }
            }
            if item.action == .export {
                if let dbFile = dbFile {
                    
                    let doc = UIDocumentPickerViewController(forExporting: [dbFile.url], asCopy: true)
                    present(doc, animated: true, completion: nil)
                    // deleteDatabase(name: dbName)
                    // print(isPr)
                }
            }
        }
        if item.action == .setPasscode {
            let vc = PasscodeLockViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}
private extension DatabaseCRUDViewController {
    func setupUI() {
        switch mode {
        case .create:
            createDataForCreateMode()
            navigationItem.title = "Create database"
            navigationItem.rightBarButtonItem = .init(
                title: "Create", style: .plain, target: self, action: #selector(createOrUpdateAction))
            navigationItem.rightBarButtonItem?.isEnabled = false
        case .edit:
            createDataForEditMode()
            navigationItem.rightBarButtonItem = .init(
                title: "Save", style: .plain, target: self, action: #selector(createOrUpdateAction))
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationItem.title = "Edit database"
        }
        
        navigationItem.leftBarButtonItem = .init(
            title: "Cancel", style: .done, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow
    }
    @objc func cancelAction() {
        dismiss(animated: true, completion: nil)
    }
    @objc func createOrUpdateAction() {
        let dbName = sections[0].items[0].value
        if mode == .create {
            let result = DatabaseFileManager.shared.createDatabase(dbName)
            switch result {
            case .success(_):
                delegate?.databaseCreated(name: dbName)
                dismiss(animated: true, completion: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    func deleteDatabase(name: String) {
        let res = DatabaseFileManager.shared.dropDatabase(name)
        switch res {
        case .success(let deletedName):
            print("#deleted db: \(deletedName)")
            delegate?.didDeleteDatabase(name: name)
            dismiss(animated: true, completion: nil)
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
    func createDataForCreateMode() {
        sections = [
            .init(title: "Name", items: [.init(title: "", value: "", cellType: .textField)], footerTitle: nil),
            .init(title: "", items: [.init(title: "Use sample database", value: "", cellType: .switchControl)], footerTitle: "If this option is selected database with sample tables will be created"),
            .init(title: "", items: [.init(title: "Turn Passcode On", value: "", cellType: .plain, action: .setPasscode)], footerTitle: "This In-App passcode allows you to block specific database on opening")
        ]
        tableView.reloadData()
    }
    func createDataForEditMode() {
        sections = [
            .init(title: "Name", items: [.init(title: "", value: "", cellType: .textField)], footerTitle: nil),
            .init(title: "", items: [.init(title: "Use sample database", value: "", cellType: .switchControl)], footerTitle: "If this option is selected database with sample tables will be created"),
            .init(title: "", items: [.init(title: "Turn Passcode On", value: "", cellType: .plain, action: .setPasscode)], footerTitle: "This In-App passcode allows you to block specific database on opening"),
            .init(title: "", items: [.init(title: "Export", value: "", cellType: .plain, action: .export)], footerTitle: nil),
            .init(title: "", items: [.init(title: "Delete", value: "", cellType: .plain, action: .delete)], footerTitle: nil)
        ]
        tableView.reloadData()
    }
}
extension DatabaseCRUDViewController: TextFieldTableCellDelegate, SwitchTableCellDelegate {
    func textDidChange(_ text: String) {
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        sections[0].items[0].value = text
    }
    func toggleDidChange(_ isOn: Bool) {
        print(isOn)
    }
}
