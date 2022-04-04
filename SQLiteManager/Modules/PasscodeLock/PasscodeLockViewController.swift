//
//  PasscodeLockViewController.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 30.01.2022.
//

import SwiftUI

extension Notification.Name {
    static let passcodeLockToBeDismissed = Notification.Name("passcodeLockToBeDismissed")
}

final class PasscodeLockViewController: UIHostingController<PasscodeLockView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    convenience init() {
        let rootView = PasscodeLockView()
        self.init(rootView: rootView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissSelf), name: .passcodeLockToBeDismissed, object: nil)
    }
    @objc func dismissSelf() {
        NotificationCenter.default.removeObserver(self, name: .passcodeLockToBeDismissed, object: nil)
        dismiss(animated: true, completion: nil)
    }
}
