//
//  SoundListViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/6/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit
import CoreData

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class SoundListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum CellID: String {
        case SoundInfo
    }
    
    enum SegueID: String {
        case SoundDetail
        case Detail
    }
    
    // MARK: - Variables
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
//    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var topContainerView: UIView!
    
    @IBOutlet weak var textFilterButton: UIButton!
    
    @IBOutlet weak var tagFilterButton: UIButton!
    
    @IBOutlet weak var userFilterButton: UIButton!
    
    var selectedFilterButton: UIButton?
    
    // MARK: - Public Properties
    
    let loader = SoundLoader()
    
    let database = DatabaseManager()
    
    var searchController: UISearchController!
    
//    var fetchController: NSFetchedResultsController<NSFetchRequestResult>!
    
    // MARK: - Private Properties
    
    fileprivate var searchContext = 0
    
    fileprivate var detailIndexPath: IndexPath?
    
    fileprivate var sounds: [SoundInfo] = []
    
    fileprivate var filterParameter: FilterParameter?
    
    // MARK: - Constructors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        configureUI()
        
//        if fetchController.fetchedObjects?.count > 0 {
//            return
//        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.searchSoundWith(text: "", sortParameter: nil, filterParameter: nil)
    }
    
    deinit {
        loader.stopLoading()
    }
    
    // MARK: - Methods of class
    
    // MARK: - Methods of instance
    
    func configureUI() {
        
        configureFetchController()
        configureNavigationBar()
        configureFilterControlls()
        configureSearchController()
        configureTableView()
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func configureFilterControlls() {
        textFilterButton.setBackgroundImage(UIImage(named: "FilterButtonSelected"), for: .selected)
        tagFilterButton.setBackgroundImage(UIImage(named: "FilterButtonSelected"), for: .selected)
        userFilterButton.setBackgroundImage(UIImage(named: "FilterButtonSelected"), for: .selected)
        
        textFilterButton.isSelected = true
        selectedFilterButton = textFilterButton
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()

    }
    
    func configureFetchController() {
        
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: SoundInfo.entityName)
//        request.sortDescriptors = []
//        request.fetchLimit = 10
//        fetchController = NSFetchedResultsController(fetchRequest: request,
//                                                     managedObjectContext: database.coreData.context,
//                                                     sectionNameKeyPath: nil, cacheName: nil)
//        fetchController.delegate = self
//        
//        do {
//            try fetchController.performFetch()
//        } catch {
//            fatalError("Error loading database data!")
//        }
//        
//        print("Config \(fetchController.fetchedObjects?.count)")
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        topContainerView.addSubview(searchController.searchBar)

        searchController.searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
        guard let identifier = segue.identifier else {
            return
        }
        
        switch identifier {
        case SegueID.SoundDetail.rawValue:
            let controller = segue.destination as! SoundDetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            
//            let soundInfo = fetchController.object(at: indexPath) as! SoundInfo
            let soundInfo = sounds[indexPath.row]
            controller.soundInfo = soundInfo
            
        case SegueID.Detail.rawValue:
            let controller = segue.destination as! DescriptionViewController
            let indexPath = tableView.indexPathForSelectedRow!
            
//            let soundInfo = fetchController.object(at: detailIndexPath!) as! SoundInfo
            let soundInfo = sounds[indexPath.row]
            controller.shortDescription = soundInfo.detailInfo?.userDescription
            
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        if sender == selectedFilterButton {
            return
        }
        
        selectedFilterButton?.isSelected = false
        sender.isSelected = true
        selectedFilterButton = sender
        
        var params:[FilterParameter] = [.tag, .username,.description, .comment]
        let index = sender.tag - 200
        
        filterParameter = (index < params.count ? params[index] : nil)
        searchSoundWith(text: searchController.searchBar.text!, sortParameter: nil, filterParameter: filterParameter)
    }
    
    // MARK: - Private methods
}

// MARK: - UITableViewDataSource
extension SoundListViewController {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundInfo.rawValue,
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
        detailIndexPath = IndexPath(row: sender.tag, section: 0)
        
        performSegue(withIdentifier: SegueID.Detail.rawValue, sender: self)
    }
}

// MARK: - UITableViewDelegate
extension SoundListViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive {
            searchController.isActive = false
        }
        
        performSegue(withIdentifier: SegueID.SoundDetail.rawValue, sender: self)
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

// MARK: - UISearchResultsUpdating
extension SoundListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text, searchString.characters.count > 1 else {
            return
        }
        searchSoundWith(text: searchString, sortParameter: nil, filterParameter: filterParameter)
    }
    
//    func searchSoundByText(_ text: String) {
//        
//        fetchController.fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", text)
//        
//        do {
//            try fetchController.performFetch()
//        } catch {
//            fatalError("Error searching: \(error)")
//        }
//        
//        if fetchController.fetchedObjects!.isEmpty ||
//            fetchController.fetchedObjects!.count <= 8 {
//            
//            print("Extra load")
//            loader.searchSoundWith(text, loadedCount: fetchController.fetchedObjects!.count) { sounds in
//                if sounds.count <= self.fetchController.fetchedObjects!.count {
//                    return
//                }
//                
//                DispatchQueue.main.async(execute: { [unowned self] in
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    try! self.fetchController.performFetch()
//                    self.tableView.reloadData()
//                    
//                })
//            }
//        } else {
//            tableView.reloadData()
//        }
//        
//    }
    
    func searchSoundWith(text: String, sortParameter: SortParameter?, filterParameter: FilterParameter?) {
        loader.searchSoundWith(text, sortParameter: sortParameter, filterParameter: filterParameter) { (sounds) in
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

// MARK: - NSFetchedResultsControllerDelegate
extension SoundListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
    }
}

// MARK: - UISearchBarDelegate
extension SoundListViewController: UISearchBarDelegate {
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        fetchController.fetchRequest.predicate = nil
//        
//        do {
//            try fetchController.performFetch()
//        } catch {
//            fatalError("Error searching: \(error)")
//        }
//        
//        tableView.reloadData()
//    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchSoundWith(text: "", sortParameter: nil, filterParameter: filterParameter)
    }
}

