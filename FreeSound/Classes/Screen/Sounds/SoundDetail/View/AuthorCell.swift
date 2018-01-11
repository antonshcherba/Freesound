//
//  AuthorCell.swift
//  FreeSound
//
//  Created by Anton Shcherba on 1/10/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import UIKit

class AuthorCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    
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
        authorLabel.font = UIFont.init(name: "AvenirNext-Bold", size: 12.0)
        authorLabel.textColor = .white
        authorLabel.backgroundColor = .clear
        authorLabel.textAlignment = .right
    }
}
