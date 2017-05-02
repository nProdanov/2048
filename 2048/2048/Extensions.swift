//
//  Extensions.swift
//  2048
//
//  Created by Nikolay Prodanow on 4/30/17.
//  Copyright © 2017 Nikolay Prodanow. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
}

extension UIColor {
    static func getCellColor(fromCellText text: String) -> UIColor {
        switch text {
        case "2":
            return UIColor.lightGray
        case "4":
            return UIColor.gray
        case "8":
            return UIColor.brown
        case "16":
            return UIColor.blue
        case "32":
            return UIColor.cyan
        case "64":
            return UIColor.red
        case "128":
            return UIColor.magenta
        case "256":
            return UIColor.purple
        case "512":
            return UIColor.green
        case "1024":
            return UIColor.yellow
        case "2048":
            return UIColor.orange
        case "4096":
            return UIColor.clear
        default:
            return UIColor.darkGray
        }
    }
}
