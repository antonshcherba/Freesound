//
//  ProfileViewController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 5/26/16.
//  Copyright © 2016 Anton Shcherba. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController : UIViewController {
    
    enum TableRow: Int {
        case sounds
        case packs
    }
    
    // MARK: - Variables
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var homepageLabel: UILabel!
    
    @IBOutlet weak var joinedDate: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var soundsCountLabel: UILabel!
    
    @IBOutlet weak var packsCountLabel: UILabel!
    
    // MARK: - Public Properties
    
    var user: User!
    
    var username = "me"
    
    // MARK: - Private Properties
    
    fileprivate let bag = DisposeBag()
    
    fileprivate let loader = SoundLoader()
    
    // MARK: - Constructors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader.loadUser(withName: username, authRequired: true)
            .subscribe(onNext: ({ [weak self] user in
                guard let strongSelf = self else { return }
                strongSelf.user = user
                DispatchQueue.main.async {
                    strongSelf.updateWith(user)
                }
            }), onError: ({ [weak self] error in
                guard let strongSelf = self else { return }
                print("error")
                print(error)
                
                let alertController = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                strongSelf.present(alertController, animated: true, completion: nil)
            })).disposed(by: bag)
        
        setupUI()
    }
    
    func setupUI() {
        setupNavigationBar()
        setupTableView()
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        if let first = navigationController?.viewControllers.first, first != self {
            return
        }
        
        let searchSettingsButton = UIButton(type: .custom)
        searchSettingsButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        searchSettingsButton.setImage(UIImage(named: "SettingsButtonIcon"), for: .normal)
        searchSettingsButton.addTarget(self, action: #selector(presentLeftViewController(_:)), for: .touchUpInside)
        
        let barItem = UIBarButtonItem(customView: searchSettingsButton);
        
        navigationItem.leftBarButtonItem = barItem
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: UserInfoCell.nibbName, bundle: nil), forCellReuseIdentifier: UserInfoCell.nibbName)
    }
    
    func updateWith(_ user: User) {
        nameLabel.text = user.name
        avatarImageView.image = user.avatar
        homepageLabel.text = user.homepage
        joinedDate.text = user.joinedDate
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Methods of class
    
    // MARK: - Methods of instance
    
    // MARK: - Actions
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private methods
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = user else { return 0 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.nibbName, for: indexPath) as! UserInfoCell
        guard let row = TableRow(rawValue: indexPath.row) else { return cell }
        
        switch row {
        case .sounds:
            cell.nameLabel.text = "Sounds"
            cell.valueLabel.text = "\(user.soundsCount)"
        case .packs:
            cell.nameLabel.text = "Packs"
            cell.valueLabel.text = "\(user.packsCount)"
        }
        
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let row = TableRow.init(rawValue: indexPath.row) else {
            return
        }
        
        switch row {
        case .sounds:
            let controller = NavigationManager.getController() as UserSoundsController
            navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
    }
}
