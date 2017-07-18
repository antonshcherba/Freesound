//
//  SoundPlayerCell.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/8/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit

class SoundPlayerCell: UITableViewCell {

    var playing = false {
        didSet {
            DispatchQueue.main.async {
                let imageName = self.playing ? "Pause" : "Play"
                self.playPauseButton.setImage(UIImage(named: imageName), for: UIControlState())
            }
        }
    }
    
    var canPlay = false {
        willSet {
            DispatchQueue.main.async {
                self.playPauseButton.isEnabled = newValue
            }
        }
    }
    
    @IBOutlet weak var plotImageView: UIImageView!
    
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBAction func playButtonTapped(_ sender: AnyObject) {
        playing = !playing
    }
    
    
    @IBAction func stopButtonTapped(_ sender: AnyObject) {
        playing = false
    }
}
