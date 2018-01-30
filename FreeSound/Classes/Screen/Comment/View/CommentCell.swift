//
//  CommentCell.swift
//  FreeSound
//
//  Created by Anton Shcherba on 7/20/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    // MARK: - Class properties
    
    static let identifier = "CommentCell"
    
    // MARK: - Properties
    
    var usernameLabel: UILabel
    
    var dateTimeLabel: UILabel
    
    var commentLabel: UILabel
    
    // MARK: - Private properties
    
    private let checkBoxOnImageName = "CommentCell"
    
    private var didSetupConstraints = false
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        usernameLabel = UILabel(frame: .zero)
        usernameLabel.textColor = UIColor.blue
        usernameLabel.font = UIFont.systemFont(ofSize: 10)
        usernameLabel.numberOfLines = 1
        usernameLabel.minimumScaleFactor = 0.5
        usernameLabel.adjustsFontSizeToFitWidth = true
        
        dateTimeLabel = UILabel(frame: .zero)
        dateTimeLabel.textColor = UIColor.red
        dateTimeLabel.font = UIFont.systemFont(ofSize: 10)
        dateTimeLabel.numberOfLines = 1
        usernameLabel.minimumScaleFactor = 0.5
        dateTimeLabel.adjustsFontSizeToFitWidth = true
        
        commentLabel = UILabel(frame: .zero)
        commentLabel.textColor = UIColor.darkGray
        commentLabel.numberOfLines = 0
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(usernameLabel)
        contentView.addSubview(dateTimeLabel)
        contentView.addSubview(commentLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            var insets = UIEdgeInsetsMake(4, 4, 4, 4)
            
            dateTimeLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(contentView.snp.top).inset(insets.top)
                make.left.equalTo(contentView.snp.left).inset(insets.left)
                make.right.equalTo(contentView.snp.right).inset(insets.right)
                
                make.height.equalTo(12)
            })
            
            usernameLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(dateTimeLabel.snp.bottom).inset(insets.top)
                make.left.equalTo(contentView.snp.left).inset(insets.left)
                make.right.equalTo(contentView.snp.right).inset(insets.right)
                
                make.height.equalTo(12)
            })
            
            commentLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(usernameLabel.snp.bottom).inset(insets.top)
                make.bottom.equalTo(contentView.snp.bottom).inset(insets.bottom)
                make.left.equalTo(contentView.snp.left).inset(insets.left)
                make.right.equalTo(contentView.snp.right).inset(insets.right)
            })
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
}
