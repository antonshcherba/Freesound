//
//  SearchOptionsController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 7/17/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//

import UIKit
import CoreData

class SearchOptionsController: UITableViewController {
    
    enum TableSection: Int {
        case sortOption = 0
        case count
    }
    
    // MARK: - Variables
    
    var sortParameter: SortParameter?
    
    var searchOptionsApply: (((SortParameter)) -> Void)?
    
    // MARK: - Outlets
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    fileprivate let screenTitle = "Search options"
    
    fileprivate var sectionTitles: [String]!
    
    fileprivate var sortParameters: [SortParameter]!
    
    fileprivate var sortTitles: [String]!
    
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
        
        sectionTitles = ["Sort by:"]
        
        configureUI()
    }
    
    deinit {
    }
    
    // MARK: - Methods of class
    
    // MARK: - Methods of instance
    
    func configureUI() {
        configureNavigationBar()
        configureTableView()
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        navigationItem.title = screenTitle
        
        let textAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func configureTableView() {
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SearchOptionsCell.self, forCellReuseIdentifier: SearchOptionsCell.identifier)
        
        
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        let applyButton = UIButton(type: .custom)
        applyButton.frame = tableFooterView.frame
        applyButton.setTitle("Apply", for: .normal)
        applyButton.setTitleColor(.red, for: .normal)
        applyButton.addTarget(self, action: #selector(applyButtonTapped(_:)), for: .touchUpInside)
        
        tableFooterView.addSubview(applyButton)
        
        tableView.tableFooterView = tableFooterView
    }
    
    // MARK: - Actions
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        guard let sortParameter = sortParameter else { return }
        
        navigationController?.popViewController(animated: true)
        searchOptionsApply?((sortParameter))
    }
    
    // MARK: - Private methods
}

// MARK: - UITableViewDataSource
extension SearchOptionsController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView,
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
    
    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchOptionsCell.identifier,
                                                 for: indexPath) as! SearchOptionsCell
        
        configureDataForCell(cell, atIndexPath: indexPath)
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraints()
        return cell
    }
    
    func configureDataForCell(_ cell: SearchOptionsCell, atIndexPath indexPath: IndexPath) {
        cell.titleLabel.text = sortTitles[indexPath.row]
        cell.isOn = (sortParameter == sortParameters[indexPath.row])
    }
}

// MARK: - UITableViewDelegate
extension SearchOptionsController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tableSection = TableSection(rawValue:indexPath.section) else { return }
        
        switch tableSection {
        case .sortOption:
            sortParameter = sortParameters[indexPath.row]
        default:
            break
        }
        
        tableView.reloadSections([indexPath.section], with: .none)

    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let tableSection = TableSection(rawValue:section) else { return nil }
        
        let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:18))
        let label = UILabel(frame: CGRect(x:10, y:5, width:tableView.frame.size.width, height:18))
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "This is a test";
        view.addSubview(label);
        view.backgroundColor = UIColor.white;
        
        label.text = sectionTitles[section]
        
        return view
        
    }
    
}
