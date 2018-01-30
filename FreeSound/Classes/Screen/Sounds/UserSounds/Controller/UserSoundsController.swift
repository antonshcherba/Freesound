//
//  UserSoundsController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 1/11/18.
//  Copyright © 2018 Anton Shcherba. All rights reserved.
//

import UIKit

class UserSoundsController: UIViewController {

    enum CellID: String {
        case SoundInfo
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var sounds: [SoundInfo] = []
    
    var user: User?
    
    let loader = SoundLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        
        if let user = user {
            self
            self.searchSoundWith(text: "", sortParameter: nil, filterParameter: nil)
            
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
//        configureFetchController()
        setupNavigationBar()
//        configureFilterControlls()
//        configureSearchController()
        setupTableView()
    }

    func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: SoundInfoCell.nibbName, bundle: nil), forCellReuseIdentifier: SoundInfoCell.nibbName)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchSoundWith(text: String, sortParameter: SortParameter?, filterParameter: FilterParameter?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let user = user else { return }
        
        loader.sounds(for: user) { (sounds) in
            if sounds.count <= 0 {
                return
            }
            self.sounds = sounds
            DispatchQueue.main.async(execute: { [unowned self] in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.tableView.reloadData()
            })
        }
    }

}

// MARK: - UITableViewDataSource
extension UserSoundsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //        return fetchController.sections?.count ?? 0
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        
        //        let sectionInfo = fetchController.sections![section]
        //        print("Fetched count: \(sectionInfo.numberOfObjects)")
        //        return sectionInfo.numberOfObjects
        
        return sounds.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SoundInfoCell.nibbName,
                                                 for: indexPath) as! SoundInfoCell
        
        configureDataForCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureDataForCell(_ cell: SoundInfoCell, atIndexPath indexPath: IndexPath) {
        //        guard let soundInfo = fetchController.object(at: indexPath) as? SoundInfo else {
        //            return
        //        }
        
        let soundInfo = sounds[indexPath.row]
        
        cell.titleLabel.text = soundInfo.name
        cell.usernameLabel.text = soundInfo.username
        cell.typeLabel.text = soundInfo.type
        cell.downloadsLabel.text = String(soundInfo.downloadsCount)
        
        //        let tags = soundInfo.tags?.allObjects.map {tag in (tag as! Tag).title }
        //        cell.tagsView.tags = tags!
        
        cell.detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        cell.detailButton.tag = indexPath.row
    }
    
    @IBAction func detailButtonTapped(_ sender: UIButton) {
//        detailIndexPath = IndexPath(row: sender.tag, section: 0)
//
//        performSegue(withIdentifier: SegueID.Detail.rawValue, sender: self)
    }
}

// MARK: - UITableViewDelegate
extension UserSoundsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if searchController.isActive {
//            searchController.isActive = false
//        }
//
//        performSegue(withIdentifier: SegueID.SoundDetail.rawValue, sender: self)
    }
    
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if indexPath.row + 1 == fetchController.fetchedObjects?.count {
    //
    //            let count = fetchController.fetchedObjects!.count
    //
    //            if database.soundsInfoCount(from: fetchController.fetchRequest) > count {
    //                fetchController.fetchRequest.fetchLimit += 5
    //
    //                do {
    //                    try fetchController.performFetch()
    //                    print("Performs extra fetch")
    //                } catch {
    //                    fatalError("Error fetching extra data: \(error)")
    //                }
    //
    //                tableView.reloadData()
    //            }
    //        }
    //    }
    
    //    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 80.0
    //    }
}
