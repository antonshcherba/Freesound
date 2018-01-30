//
//  UserInfoCell.swift
//  FreeSound
//
//  Created by Anton Shcherba on 1/11/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        nameLabel.font = UIFont.init(name: "AvenirNext-Bold", size: 13.0)
        nameLabel.textColor = .white
        nameLabel.backgroundColor = .clear
        nameLabel.textAlignment = .left
        
        valueLabel.font = UIFont.init(name: "AvenirNext-Bold", size: 12.0)
        valueLabel.textColor = .white
        valueLabel.backgroundColor = .clear
        valueLabel.textAlignment = .right
    }
}
