//
//  SoundDetailViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/7/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMaps

class SoundDetailViewController: UIViewController {

    enum CellID: String {
        case SoundTitle
        case SoundPlayer
        case MetaInfo
        case SoundTags
        case SoundDescription
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var soundLoadingView: UIActivityIndicatorView!
    
    @IBOutlet weak var playerView: SoundPlayerView!
    
    // MARK: - Public Properties
    
    let loader = SoundLoader()
    
    var soundInfo: SoundInfo!
    
    var metaInfoCount = 4
    
    var soundPlayer: AVAudioPlayer?
    
    let database = DatabaseManager()
    
    let playerController = SoundPlayerController()
    
    // MARK: - Constructors

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureData()
        configureUI()
        
//        let controller = SoundPlayerController()
        let controller = playerController
        if let view = controller.view {
            view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 320)
        }
        
        tableView.tableHeaderView = controller.view
        
        controller.playerView.playPauseButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        let aa = controller.playerView.playPauseButton.actions(forTarget: self, forControlEvent: .touchUpInside)
        
    }
    
    
    func configureData() {
        if let detailInfo = soundInfo.detailInfo {
            configurePlayer()
        } else {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            loader.loadSoundWithID(Int(soundInfo.id)) { (detailInfo) in
                DispatchQueue.main.async { [unowned self] in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    self.soundInfo.detailInfo = detailInfo
                    self.database.saveObject(detailInfo!)
                    self.tableView.reloadData()
                    
                    self.configurePlayer()
                }
            }
        }
    }
    
    func configurePlayer() {
//        playerView.canPlay = false
//        soundLoadingView.hidesWhenStopped = true
//        soundLoadingView.startAnimating()
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            guard let soundInfo = strongSelf.soundInfo else { return }
            
            guard let detailInfo = strongSelf.soundInfo.detailInfo else {
                DispatchQueue.main.async(execute: {
//                    strongSelf.soundLoadingView.stopAnimating()
                    let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        NSLog("OK Pressed")
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
                        UIAlertAction in
                        NSLog("Cancel Pressed")
                    }
                    
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    
                    strongSelf.present(alertController, animated: true, completion: nil)
                })
                return
            }
            
            let url = URL(string: strongSelf.soundInfo.detailInfo!.previewSound)
            guard let data = try? Data(contentsOf: url!) else {
//                DispatchQueue.main.async(execute: {
//                    strongSelf.soundLoadingView.stopAnimating()
//                })
                return
            }
            let fileURL = saveFile(name: soundInfo.fullName!, data: data)
            
            strongSelf.playerController.audioFileURL = fileURL
            let fileData: Data?
            do {
                 fileData = try Data(contentsOf: fileURL)
            } catch {
                print(error.localizedDescription)
                return
            }
            
            guard let fileDataa = fileData else { return }
            
            do {
                strongSelf.soundPlayer = try AVAudioPlayer(data: fileDataa)
//                strongSelf.playerView.canPlay = true
            } catch {
                print("Error playing sound: ")//\(error.localizedDescription)")
            }
            DispatchQueue.main.async(execute: { 
//                strongSelf.soundLoadingView.stopAnimating()
            })
            
        }
    }
    
    func configureUI() {
        self.definesPresentationContext = true
        configureTableView()
        configureNavigationBar()
        configurePlayerView()
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func configurePlayerView() {
        
        if let info = soundInfo.detailInfo,
            let url = URL(string: info.image),
            let data = try? Data(contentsOf: url) {
//            playerView.plotImageView.image = UIImage(data: data)
        }
    }
    
    var firstTapped = true
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if soundPlayer!.isPlaying {
            soundPlayer?.pause()
        } else {
            soundPlayer?.play()
        }
    }
    
    @IBAction func stopButtonTapped(_ sender: UIButton) {
        
        if soundPlayer!.isPlaying {
            soundPlayer?.stop()
            soundPlayer?.currentTime = 0.0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else {
            return
        }
        
        switch id {
        case "Player":
            let controller = segue.destination as! PlayerModalViewController
            
            if let data = try? Data(contentsOf: URL(string: soundInfo.detailInfo!.image)!) {
                controller.soundImage = UIImage(data: data)!
            }
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension SoundDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if soundInfo.detailInfo == nil {
            return 0
        }
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if soundInfo.detailInfo == nil {
            return 0
        }
        
        let rowCount: Int
        switch section {
        case 0:
            rowCount = 1
        case 1:
            rowCount = metaInfoCount
        case 2:
            rowCount = 1
        case 3:
            rowCount = (soundInfo.latitude != 0 ? 1 : 0)
        case 4:
            rowCount = 1
        default:
            rowCount = 0
        }
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundTitle.rawValue,
                                                                   for: indexPath) as! SoundTitleCell
            cell.titleLabel.text = soundInfo.name
            return cell
            
//        case 1:
//            let cell = tableView.dequeueReusableCellWithIdentifier(CellID.SoundPlayer.rawValue,
//                                                                   forIndexPath: indexPath) as! SoundPlayerCell
//            
//            if let data = NSData(contentsOfURL: NSURL(string: soundInfo.detailInfo!.image)!) {
//                cell.plotImageView.image = UIImage(data: data)!
//            }
////            cell.plotImageView.image = soundDetailInfo?.image
//            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.MetaInfo.rawValue,
                                                                   for: indexPath) as! MetaInfoCell
            configureMetaInfoCell(cell, forIndexPath: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundTags.rawValue,
                                                                   for: indexPath) as! SoundTagsCell
            
            cell.tags = soundInfo.tags!.map {($0 as AnyObject).title}//soundDetailInfo!.tags
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundTitle.rawValue,
                                                     for: indexPath) as! SoundTitleCell
            
            cell.titleLabel.text = "Show on Map"
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundDescription.rawValue,
                                                                   for: indexPath) as! SoundDescriptionCell
            cell.textView.text = soundInfo.detailInfo!.userDescription
            return cell
        default:
//            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
            return tableView.dequeueReusableCell(withIdentifier: CellID.SoundTitle.rawValue)!
        }
    }
    
    func configureMetaInfoCell(_ cell: MetaInfoCell, forIndexPath indexPath: IndexPath) {
        guard let meta = MetaInfoCell.Description(rawValue: indexPath.row) else {
            return
        }
        
        switch meta {
        case MetaInfoCell.Description.type:
            cell.setDescription("Type", withValue: soundInfo.detailInfo!.typeEnum.title)
        case MetaInfoCell.Description.bitrate:
            cell.setDescription("Bitrate", withValue: String(soundInfo.detailInfo!.bitrate))
        case MetaInfoCell.Description.duration:
            cell.setDescription("Duration", withValue: soundInfo.detailInfo!.duration.stringValue)
        case MetaInfoCell.Description.filesize:
            cell.setDescription("Filesize", withValue: soundInfo.detailInfo!.filesize.stringValue)
        default:
            break
        }
    }
    
    
}

func saveFile(name: String, data: Data) -> URL {
    let fileURL = try! FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask, appropriateFor: nil, create: false)
        .appendingPathComponent(name)
    
    do {
        try data.write(to: fileURL, options: .atomic)
    } catch {
        print(error)
    }
    
    return fileURL
}

extension SoundDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            guard let soundInfo = self.soundInfo else {
                return
            }
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: soundInfo.latitude,
                                                     longitude: soundInfo.longitude)
            marker.title = soundInfo.name
            marker.snippet = "by \(soundInfo.username!)"
            
            let controller = SoundMapController()
            controller.soundMarker = marker
            navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
}

