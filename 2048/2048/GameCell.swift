//
//  GameCell.swift
//  2048
//
//  Created by Nikolay Prodanow on 4/30/17.
//  Copyright © 2017 Nikolay Prodanow. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellTextLabel: UILabel!
    
    var cellText: String? {
        get {
            return cellTextLabel.text
        }
        
        set {
            cellTextLabel.text = newValue
        }
    }
}
