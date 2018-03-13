//
//  SoundPlayerController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 7/13/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//

import UIKit
import EZAudio
import RxSwift
import RxCocoa

@objcMembers class SoundPlayerController: UIViewController, EZAudioPlayerDelegate {

    var player: EZAudioPlayer!
    
    var playerView: SoundPlayerView!
    
    var audioFileURL: URL? {
        didSet {
            guard let plotView = playerView.plotView else { return }
            plotView.audioURL = audioFileURL


            guard let url = audioFileURL else { return }
            player = EZAudioPlayer(url: url, delegate: self)
            
//            audioFile = EZAudioFile(url: url)
//            
//            let frames:UInt32 = UInt32(audioFile.totalFrames)
//            audioFile.getWaveformData(withNumberOfPoints: 1024*10) { [weak self] (data, length) in
//                guard let plotView = self?.playerView.plotView else {
//                    return
//                }
//                
//                guard let plotData = data?[0] else {
//                    return
//                }
//                
//                plotView.updateBuffer(plotData, withBufferSize: UInt32(length))
//            }
        }
    }

    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 200)
        self.playerView = SoundPlayerView(frame:rect)
        self.view = self.playerView
        
        playerView.playing = false
        setupObservers()
    }
    
    func setupObservers() {
        playerView.playPauseButton.rx.tap.subscribe(onNext: ({ [weak self] in
            guard let strongSelf = self else { return }
            
            guard let _ = strongSelf.player else { return }
            
            if strongSelf.player.isPlaying {
                strongSelf.player?.pause()
            } else {
                strongSelf.player?.play()
            }
            strongSelf.playerView.playing = strongSelf.player.isPlaying
        })).disposed(by: bag)
    }
}

extension SoundPlayerController {
    func audioPlayer(_ audioPlayer: EZAudioPlayer!, updatedPosition framePosition: Int64, in audioFile: EZAudioFile!) {
        DispatchQueue.main.async {
            self.playerView.plotView.progressSamples = Int(framePosition)
        }
    }
}
