//
//  ProfileUserView.swift
//  FreeSound
//
//  Created by Anton Shcherba on 3/15/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import UIKit

class ProfileUserView: UIView {

    let nameLabel: UILabel
    
    let avatarImageView: UIImageView
    
    let homepageLabel: UILabel
    
    let joinedDateTitleLabel: UILabel
    
    let joinedDateLabel: UILabel
    
    let dateView: UIStackView
    
    override init(frame: CGRect) {
        nameLabel = UILabel(frame: .zero)
        
        avatarImageView = UIImageView(frame: .zero)
        
        homepageLabel = UILabel(frame: .zero)
        
        joinedDateTitleLabel = UILabel(frame: .zero)
        
        joinedDateLabel = UILabel(frame: .zero)
        
        dateView = UIStackView(arrangedSubviews: [joinedDateTitleLabel, joinedDateLabel])
        
        super.init(frame: frame)
        self.addSubview(nameLabel)
        self.addSubview(avatarImageView)
        self.addSubview(homepageLabel)
        self.addSubview(dateView)
        
        homepageLabel.font = UIFont.systemFont(ofSize: 13)
        homepageLabel.textColor = UIColor.white
        homepageLabel.textAlignment = .center
        
        nameLabel.font = UIFont(name: "Futura-Medium", size: 24)
        nameLabel.textColor = UIColor.white
        nameLabel.textAlignment = .center
        
        joinedDateTitleLabel.text = "Registered at"
        joinedDateTitleLabel.font = UIFont.systemFont(ofSize: 11)//Future medium
        joinedDateTitleLabel.textColor = UIColor(red: 230 / 255.0, green: 55 / 255.0, blue: 94 / 255.0, alpha: 1.0)
        joinedDateTitleLabel.textAlignment = .center
        
        joinedDateLabel.font = UIFont.systemFont(ofSize: 11)//Future medium
        joinedDateLabel.textColor = UIColor.white
        joinedDateLabel.textAlignment = .center
        
        dateView.axis = .vertical
        dateView.distribution = .fillEqually
        
        avatarImageView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.snp.top).inset(32)
            
            make.height.equalTo(128)
            make.width.equalTo(128)
            make.centerX.equalTo(self.snp.centerX)
        })
        
        homepageLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(avatarImageView.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
        })
        
        nameLabel.snp.makeConstraints({ (make) in
            make.top.equalTo(homepageLabel.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            
            make.height.equalTo(32)
        })
        
        dateView.snp.makeConstraints({ (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom).inset(8)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("No NO ProfileUserView")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup() {
        
    }
}
