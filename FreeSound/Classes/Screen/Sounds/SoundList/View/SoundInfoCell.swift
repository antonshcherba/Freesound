//
//  SoundInfoCell.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/6/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit

class SoundInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var downloadsLabel: UILabel!
    
    @IBOutlet weak var tagsView: TagsView!
    
    @IBOutlet weak var detailButton: UIButton!
}
