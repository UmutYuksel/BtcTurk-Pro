//
//  Extension+UiColor.swift
//  BtcTurk Case
//
//  Created by BTCYZ188 on 8.03.2023.
//

import Foundation
import UIKit

extension UIColor {
    
    static func greyTint() -> UIColor {
            return UIColor.rgb(red: 143, green: 152, blue: 166)
        }
    static func goldTint() -> UIColor {
            return UIColor.rgb(red: 245, green: 166, blue: 35)
        }
    static func darkBlueTint() -> UIColor {
            return UIColor.rgb(red: 9, green: 16, blue: 27)
        }
    static func blueTint() -> UIColor {
            return UIColor.rgb(red: 27, green: 35, blue: 46)
        }
    static func chartTint() -> UIColor {
            return UIColor.rgb(red: 44, green: 105, blue: 138)
        }
    static func chartFillTint() -> UIColor {
            return UIColor.rgb(red: 20, green: 37, blue: 52)
        }
    static func greenTint() -> UIColor {
            return UIColor.rgb(red: 0, green: 156, blue: 33)
        }
    static func redTint() -> UIColor {
            return UIColor.rgb(red: 214, green: 48, blue: 30)
        }
    static func chartBackground() -> UIColor {
            return UIColor.rgb(red: 21, green: 25, blue: 37)
        }
    
    static func rgb(red : CGFloat, green : CGFloat, blue : CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    
}
