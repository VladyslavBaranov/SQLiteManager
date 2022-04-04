//
//  RandomColorGenerator.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 30.01.2022.
//

import UIKit

final class RandomColorGenerator {
    static func getColor(interfaceStyle: UIUserInterfaceStyle) -> UIColor {
        
        let range: ClosedRange<CGFloat> = interfaceStyle == .light ? 0.85...0.95 : 0.05...0.22
        
        let randR = CGFloat.random(in: range)
        let randG = CGFloat.random(in: range)
        let randB = CGFloat.random(in: range)
        return .init(red: randR, green: randG, blue: randB, alpha: 1)
    }
}
