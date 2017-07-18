//
//  TagsView.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/18/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit

class TagsView: UICollectionView {

    enum CellID: String {
        case TagCell
    }
    
    var tags = [String]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = UIColor.clear
        
        self.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: CellID.TagCell.rawValue)
    }
}

extension TagsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.TagCell.rawValue,
                                                                         for: indexPath) as! TagCell
        
        cell.tagLabel.text = tags[indexPath.row]
        return cell
    }
}

extension TagsView: UICollectionViewDelegateFlowLayout {
    
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
