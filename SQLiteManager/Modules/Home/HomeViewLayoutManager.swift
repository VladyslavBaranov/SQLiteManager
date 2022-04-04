//
//  HomeViewLayoutManager.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//

import UIKit

struct ViewControllerLayoutManager {
    let cellSpacing: CGFloat = 10
    func cellsForRow(windowFrame: CGRect, traitCollection: UITraitCollection) -> Int {
        let device = UIDevice.current.userInterfaceIdiom
        let orientation = UIDevice.current.orientation
     
        switch device {
        case .phone:
            return 1
        case .pad:
            let dimension = UIScreen.main.bounds.width
            let fraction = windowFrame.width / dimension

            switch fraction {
            case 0...0.4:
                return 1
            case 0.4...0.5:
                return 2
            case 0.6..<1:
                switch orientation {
                case .portrait, .portraitUpsideDown:
                    return 2
                default:
                    return 3
                }
            case 1:
                
                switch orientation {
                case .portrait, .portraitUpsideDown:
                    return 3
                default:
                    return 4
                }
            default:
                return 2
            }
            
        default:
            return 1
        }
    }
    
    
}
