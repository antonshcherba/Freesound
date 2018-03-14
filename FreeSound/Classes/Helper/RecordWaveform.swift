//
//  RecordWaveform.swift
//  FreeSound
//
//  Created by Anton Shcherba on 3/14/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import UIKit

class RecordWaveform: UIView {
    
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.clear(bounds)
    }
}
