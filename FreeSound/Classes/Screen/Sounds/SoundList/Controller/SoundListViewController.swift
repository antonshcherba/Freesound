
//
//  SoundListViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/6/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

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


class SoundListViewController: UIViewController {

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
    
    fileprivate var bag = DisposeBag()
    
    fileprivate var searchContext = 0
    
    fileprivate var detailIndexPath: IndexPath?
    
    fileprivate var sounds = Variable([SoundInfo]())
    
    fileprivate var filterParameter: FilterParameter?
    
    fileprivate var sortParameter: SortParameter?
    
    // MARK: - Constructors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        configureUI()
        setupObservers()
        
//        if fetchController.fetchedObjects?.count > 0 {
//            return
//        }
        
        sortParameter = .relevance
        self.searchSoundWith(text: "", sortParameter: sortParameter, filterParameter: nil)
    }
    
    deinit {
        loader.stopLoading()
    }
    
    // MARK: - Methods of class
    
    // MARK: - Methods of instance
    
    func setupObservers() {
        
        sounds.asObservable().bind(to: tableView.rx.items(cellIdentifier: CellID.SoundInfo.rawValue)) { _, sound, cell in
            self.configureDataForCell(cell, soundInfo: sound)
            }.disposed(by: bag)
        
        tableView.rx.modelSelected(SoundInfo.self).subscribe(onNext: { sound in
            if self.searchController.isActive {
                self.searchController.isActive = false
            }
            
            self.performSegue(withIdentifier: SegueID.SoundDetail.rawValue, sender: sound)
        }).disposed(by: bag)
        
        searchController.searchBar.rx.text.filter({ text in
            text?.count > 3
        }).subscribe(onNext: { searchString in
            guard let searchString = searchString else { return }
            
            self.searchSoundWith(text: searchString, sortParameter: self.sortParameter, filterParameter: self.filterParameter)
        }).disposed(by: bag)
    }
    
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
        
        let searchSettingsButton = UIButton(type: .custom)
        searchSettingsButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchSettingsButton.setImage(UIImage(named: "SettingsButtonIcon"), for: .normal)
        searchSettingsButton.addTarget(self, action: #selector(searchSettingsButtonTapped(_:)), for: .touchUpInside)
        
        let barItem = UIBarButtonItem(customView: searchSettingsButton);
        
        navigationItem.rightBarButtonItem = barItem
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
//        tableView.delegate = self
//        tableView.dataSource = self
        
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
            let soundInfo = sender as! SoundInfo
            controller.soundInfo = soundInfo

        case SegueID.Detail.rawValue:
            let controller = segue.destination as! DescriptionViewController
            let indexPath = tableView.indexPathForSelectedRow!

//            let soundInfo = fetchController.object(at: detailIndexPath!) as! SoundInfo
            let soundInfo = sender as! SoundInfo
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
        searchSoundWith(text: searchController.searchBar.text!, sortParameter: sortParameter, filterParameter: filterParameter)
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let oneAction = UIAlertAction(title: "Download", style: .default) { _ in }
        let twoAction = UIAlertAction(title: "Add to bookmarks", style: .default) { _ in }
        let threeAction = UIAlertAction(title: "Share", style: .default) { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        actionController.addAction(oneAction)
        actionController.addAction(twoAction)
        actionController.addAction(threeAction)
        actionController.addAction(cancelAction)
        
        self.present(actionController, animated: true, completion: nil)

    }
    
    @objc func searchSettingsButtonTapped(_ sender: UIButton) {
        let controller = SearchOptionsController()
        controller.sortParameter = sortParameter
        
        controller.searchOptionsApply = { params in
            self.sortParameter = params
            self.searchSoundWith(text: self.searchController.searchBar.text!,
                                 sortParameter: self.sortParameter,
                                 filterParameter: self.filterParameter)
        }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Private methods
}

// MARK: - UITableViewDataSource
extension SoundListViewController {

//    func numberOfSections(in tableView: UITableView) -> Int {
////        return fetchController.sections?.count ?? 0
//        return 1
//    }
    
//    func tableView(_ tableView: UITableView,
//                            numberOfRowsInSection section: Int) -> Int {
//
////        let sectionInfo = fetchController.sections![section]
////        print("Fetched count: \(sectionInfo.numberOfObjects)")
////        return sectionInfo.numberOfObjects
//
//        return sounds.count
//    }
    
//    func tableView(_ tableView: UITableView,
//                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.SoundInfo.rawValue,
//                                                               for: indexPath) as! SoundInfoCell
//
//        configureDataForCell(cell, atIndexPath: indexPath)
//
//        return cell
//    }
    
//    func configureDataForCell(_ cell: SoundInfoCell, atIndexPath indexPath: IndexPath) {
////        guard let soundInfo = fetchController.object(at: indexPath) as? SoundInfo else {
////            return
////        }
//
//        let soundInfo = sounds[indexPath.row]
//
//        cell.titleLabel.text = soundInfo.name
//        cell.usernameLabel.text = soundInfo.username
//        cell.typeLabel.text = soundInfo.type
//        cell.downloadsLabel.text = String(soundInfo.downloadsCount)
//
////        let tags = soundInfo.tags?.allObjects.map {tag in (tag as! Tag).title }
////        cell.tagsView.tags = tags!
//
//        cell.detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
//        cell.detailButton.tag = indexPath.row
//    }

    func configureDataForCell(_ cell: SoundInfoCell, soundInfo: SoundInfo) {
        cell.titleLabel.text = soundInfo.name
        cell.usernameLabel.text = soundInfo.username
        cell.typeLabel.text = soundInfo.type
        cell.downloadsLabel.text = String(soundInfo.downloadsCount)
        
        //        let tags = soundInfo.tags?.allObjects.map {tag in (tag as! Tag).title }
        //        cell.tagsView.tags = tags!
        
        cell.detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
//        cell.detailButton.tag = indexPath.row
    }
    
    @IBAction func detailButtonTapped(_ sender: UIButton) {
//        detailIndexPath = IndexPath(row: sender.tag, section: 0)

        
        guard let detailIndexPath = tableView.indexPath(for: sender.superview!.superview as! UITableViewCell) else { return }
        
        performSegue(withIdentifier: SegueID.Detail.rawValue, sender: sounds.value[detailIndexPath.row])
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
extension SoundListViewController {
    
    func searchSoundWith(text: String, sortParameter: SortParameter?, filterParameter: FilterParameter?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loader.searchSoundWith(text, sortParameter: sortParameter, filterParameter: filterParameter) { (sounds) in
            if sounds.count <= 0 {
                return
            }
//            self.sounds = sounds
            self.sounds.value = sounds
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
        searchSoundWith(text: "", sortParameter: sortParameter, filterParameter: filterParameter)
    }
}

