//
//  SoundTagsCell.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/8/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit

class SoundTagsCell: UITableViewCell {

    enum CellID: String {
        case SoundTag
    }
    
    var tags = [String]()
    
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self
        
        tagsCollectionView.backgroundColor = UIColor.clear
    }
    
//    override func systemLayoutSizeFittingSize(targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
//        tagsCollectionView.frame = CGRectMake(0.0, 0.0, targetSize.width, CGFloat.max)
//        tagsCollectionView.layoutIfNeeded()
//        
//        return tagsCollectionView.collectionViewLayout.collectionViewContentSize()
//    }
}

extension SoundTagsCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.SoundTag.rawValue,
                                                                         for: indexPath) as! TagCell
        
        cell.tagLabel.text = tags[indexPath.row]
        return cell
    }
}

extension SoundTagsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        var size: CGSize
        size = (tags[indexPath.row] as NSString).size(attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 17.0)])
        
        size.width += 32 + 10
        size.height += 10
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}
