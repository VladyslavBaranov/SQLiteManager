//
//  UIColor+Extension.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 08.02.2022.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let r = CGFloat(red) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
