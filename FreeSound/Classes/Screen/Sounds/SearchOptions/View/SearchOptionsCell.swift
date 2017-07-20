//
//  SearchOptionsCell.swift
//  FreeSound
//
//  Created by chiuser on 7/17/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//

import UIKit

class SearchOptionsCell: UITableViewCell {

    // MARK: - Class properties
    
    static let identifier = "SearchOptionsCell"
    
    // MARK: - Properties
    
    var titleLabel: UILabel
    
    var checkBoxButton: UIButton
    
    var isOn: Bool {
        didSet {
            checkBoxButton.isSelected = isOn
        }
    }
    
    // MARK: - Private properties
    
    private let checkBoxOnImageName = "SearchOptionOnButton"
    
    private var didSetupConstraints = false
    
    // MARK: - Init
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        isOn = false
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = UIColor.darkGray
        
        checkBoxButton = UIButton(type: .custom)
        checkBoxButton.isUserInteractionEnabled = false
        checkBoxButton.setImage(UIImage(named: checkBoxOnImageName), for: .selected)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkBoxButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func updateConstraints() {
        if !didSetupConstraints {
            titleLabel.snp.makeConstraints({ (make) in
                make.edges.equalTo(contentView)
            })
            
            var insets = UIEdgeInsetsMake(4, 0, 4, 8)
            checkBoxButton.snp.makeConstraints({ (make) in
                make.top.equalTo(contentView.snp.top).inset(insets.top)
                make.bottom.equalTo(contentView.snp.bottom).inset(insets.bottom)
                make.right.equalTo(contentView.snp.right).inset(insets.right)
                
                make.width.equalTo(contentView.snp.width).dividedBy(4)
            })
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
}
