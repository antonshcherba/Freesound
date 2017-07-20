//
//  MetaInfoCell.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/8/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit

class MetaInfoCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    enum Description: Int {
        case type
        case bitrate
        case duration
        case filesize
    }
    
    func setDescription(_ description: String?, withValue value: String?) {
        descriptionLabel.text = description
        valueLabel.text = value
    }
}
