//
//  SoundPlayerView.swift
//  FreeSound
//
//  Created by Anton Shcherba on 9/12/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit
import Masonry
import EZAudio
import SnapKit
import FDWaveformView

class SoundPlayerView: UIView {

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
                self.stopButton.isEnabled = newValue
            }
        }
    }
    
    var didSetupConstraints = false
    
//    var plotView: EZAudioPlot!
    var plotView: FDWaveformView!
    
    var playPauseButton: UIButton!
    
    var timeLabel: UILabel!
    
    var controllsView: UIView!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func playButtonTapped(_ sender: AnyObject) {
        playing = !playing
    }
    
    @IBAction func stopButtonTapped(_ sender: AnyObject) {
        playing = false
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        plotView = FDWaveformView()
//        plotView = EZAudioPlot(frame: frame)
        self.addSubview(plotView)
        self.setupAudioPlot()
        
        playPauseButton = UIButton(frame: frame)
        playPauseButton.setTitle("PLAY", for: .normal)
        playPauseButton.setTitleColor(UIColor.red, for: .normal)
        playPauseButton.isUserInteractionEnabled = true
        
        controllsView = UIView(frame: .zero)
        self.addSubview(controllsView)
        
        controllsView.addSubview(playPauseButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateConstraints() {
        if (!self.didSetupConstraints) {
            plotView.snp.makeConstraints({ (make) in
                make.top.equalTo(self.snp.top)
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
            })
            
            controllsView.snp.makeConstraints({ (make) in
                make.top.equalTo(plotView.snp.bottom)
                make.bottom.equalTo(self.snp.bottom)
                make.left.equalTo(self.snp.left)
                make.right.equalTo(self.snp.right)
                
                make.height.equalTo(self.snp.height).dividedBy(5)
            })
            
            playPauseButton.snp.makeConstraints({ (make) in
                make.top.equalTo(controllsView.snp.top)
                make.bottom.equalTo(controllsView.snp.bottom)
//                make.left.equalTo(self.snp.left)
//                make.right.equalTo(self.snp.right)
                
                make.width.equalTo(playPauseButton.snp.height)
                make.centerX.equalTo(controllsView.snp.centerX)
            })
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    func setupAudioPlot() {
        
//        plotView.backgroundColor = UIColor.white
//        plotView.color = UIColor.blue
//        plotView.plotType = EZPlotType.buffer
//        plotView.shouldFill = true
//        plotView.shouldMirror = true
//        plotView.shouldOptimizeForRealtimePlot = false
        
        plotView.doesAllowScrubbing = false
        plotView.doesAllowStretch = false
        plotView.doesAllowScroll = false
        
        plotView.wavesColor = UIColor.green
        plotView.progressColor = UIColor.yellow
        
        backgroundColor = UIColor.black
    }
}
