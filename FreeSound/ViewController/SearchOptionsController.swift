//
//  SearchOptionsController.swift
//  FreeSound
//
//  Created by chiuser on 7/17/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//

import UIKit

//
//  SoundListViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/6/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit
import CoreData

class SearchOptionsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum TableSection: Int {
        case sortOption = 0
        case count
    }
    
    // MARK: - Variables
    
    var sortParameter: SortParameter?
    
    var sortParameters: [SortParameter]!
    
    var sortTitles: [String]!
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortParameters = [.relevance,
                          .duration,
                          .rating,
                          .downloads]
        
        sortTitles = ["Relevance",
                      "Duration",
                      "Rating",
                      "Downloads count"]
        
        configureUI()
    }
    
    deinit {
    }
    
    // MARK: - Methods of class
    
    // MARK: - Methods of instance
    
    func configureUI() {
        
//        configureFetchController()
//        configureNavigationBar()
//        configureFilterControlls()
//        configureSearchController()
        configureTableView()
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func configureFilterControlls() {

    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchOptionsCell.self, forCellReuseIdentifier: SearchOptionsCell.identifier)
    }
    
    // MARK: - Actions
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {

    }
    
    // MARK: - Private methods
}

// MARK: - UITableViewDataSource
extension SearchOptionsController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.count.rawValue
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let tableSection = TableSection(rawValue: section) else { return 0 }
        let rowsCount: Int
        
        switch tableSection {
        case .sortOption:
            rowsCount = sortParameters.count
        default:
            rowsCount = 0
        }
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchOptionsCell.identifier,
                                                 for: indexPath) as! SearchOptionsCell
        
        configureDataForCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureDataForCell(_ cell: SearchOptionsCell, atIndexPath indexPath: IndexPath) {
        //        guard let soundInfo = fetchController.object(at: indexPath) as? SoundInfo else {
        //            return
        //        }
        
//        let soundInfo = sounds[indexPath.row]
        
        cell.titleLabel.text = sortTitles[indexPath.row]
        cell.isOn = (sortParameter == sortParameters[indexPath.row])
        
        //        let tags = soundInfo.tags?.allObjects.map {tag in (tag as! Tag).title }
        //        cell.tagsView.tags = tags!
        
//        cell.detailButton.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
//        cell.detailButton.tag = indexPath.row
    }
    
    @IBAction func checkBoxButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? UITableViewCell else { return }
        
//        let indexPath = IndexPath(row: sender.tag, section: 0)
        guard let indexPath = tableView.indexPath(for: cell),
            let tableSection = TableSection(rawValue:indexPath.section) else { return }
        
        switch tableSection {
        case .sortOption:
            sortParameter = sortParameters[indexPath.row]
        default:
            break
        }
        
        tableView.reloadSections([indexPath.section], with: .none)
    }
}

// MARK: - UITableViewDelegate
extension SearchOptionsController {
    
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
}
