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
    
    enum TableSection: Int {
        case title = 0
        case metaInfo
        case tags
        case map
        case comments
        case description
        case count
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
    
    // MARK: - Private Properties
    
    fileprivate let metaTitles:[MetaInfoCell.Description: String] = [.type: "Type",
                                                                     .bitrate: "Bitrate",
                                                                     .duration: "Duration",
                                                                     .filesize: "Filesize"]
    // MARK: - Livecycle

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
        
        return TableSection.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if soundInfo.detailInfo == nil {
            return 0
        }
        
        guard let tableSection = TableSection(rawValue:section) else { return 0 }
        
        let rowCount: Int
        switch tableSection {
        case .title:
            rowCount = 1
        case .metaInfo:
            rowCount = metaInfoCount
        case .tags:
            rowCount = 1
        case .map:
            rowCount = (soundInfo.latitude != 0 ? 1 : 0)
            
        case .comments:
            rowCount = 1
        case .description:
            rowCount = 1
        default:
            rowCount = 0
        }
        
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableSection = TableSection(rawValue:indexPath.section) else {
            return tableView.dequeueReusableCell(withIdentifier: CellID.SoundTitle.rawValue)!
        }
        
        switch tableSection {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundTitle.rawValue,
                                                                   for: indexPath) as! SoundTitleCell
            cell.titleLabel.text = soundInfo.name
            return cell
        case .metaInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.MetaInfo.rawValue,
                                                                   for: indexPath) as! MetaInfoCell
            configureMetaInfoCell(cell, forIndexPath: indexPath)
            return cell
        case .tags:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundTags.rawValue,
                                                                   for: indexPath) as! SoundTagsCell
            
            cell.tags = soundInfo.tags!.map {($0 as AnyObject).title}//soundDetailInfo!.tags
            return cell
            
        case .map:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundTitle.rawValue,
                                                     for: indexPath) as! SoundTitleCell
            
            cell.titleLabel.text = "Show on Map"
            return cell
        case .map:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundTitle.rawValue,
                                                     for: indexPath) as! SoundTitleCell
            
            cell.titleLabel.text = "Show comments"
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundDescription.rawValue,
                                                                   for: indexPath) as! SoundDescriptionCell
            cell.textView.text = soundInfo.detailInfo!.userDescription
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: CellID.SoundTitle.rawValue)!
        }
    }
    
    func configureMetaInfoCell(_ cell: MetaInfoCell, forIndexPath indexPath: IndexPath) {
        guard let meta = MetaInfoCell.Description(rawValue: indexPath.row) else {
            return
        }
        
        let title = metaTitles[meta]
        let value: String
        
        switch meta {
        case MetaInfoCell.Description.type:
            value = soundInfo.detailInfo!.typeEnum.title
        case MetaInfoCell.Description.bitrate:
            value = String(soundInfo.detailInfo!.bitrate)
        case MetaInfoCell.Description.duration:
            value = soundInfo.detailInfo!.duration.stringValue
        case MetaInfoCell.Description.filesize:
            value = soundInfo.detailInfo!.filesize.stringValue
        default:
            break
        }
        
        cell.setDescription(title, withValue: soundInfo.detailInfo!.filesize.stringValue)
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
        guard let tableSection = TableSection(rawValue:indexPath.section) else { return }
        
        switch tableSection {
        case .map:
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
        case .comments:
            break
        default:
            break
        }
    }
}

