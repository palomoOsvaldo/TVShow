//
//  Colors.swift
//  TVShow
//
//  Created by Osvaldo Salas on 17/03/22.
//

import Foundation
import UIKit

extension UIColor {
    static func backgroundBtn() -> UIColor {
        return UIColor(displayP3Red: 212/255, green: 210/255, blue: 204/255, alpha: 1)
    }
    
    static func colorError() -> UIColor {
        return UIColor(displayP3Red: 185/255, green: 76/255, blue: 37/255, alpha: 1)
    }
    
    static func backgoundCell() -> UIColor {
        return UIColor(displayP3Red: 24/255, green: 39/255, blue: 45/255, alpha: 1)
    }
    
    static func fontColor() -> UIColor {
        return UIColor(displayP3Red: 98/255, green: 203/255, blue: 114/255, alpha: 1)
    }
    
    static func navigation() -> UIColor {
        return UIColor(displayP3Red: 48/255, green: 55/255, blue: 58/255, alpha: 1)
    }
    
    static func segmented() -> UIColor {
        return UIColor(displayP3Red: 25/255, green: 32/255, blue: 38/255, alpha: 1)
    }
    
    static func segmentedSelected() -> UIColor {
        return UIColor(displayP3Red: 98/255, green: 99/255, blue: 101/255, alpha: 1)
    }
}
