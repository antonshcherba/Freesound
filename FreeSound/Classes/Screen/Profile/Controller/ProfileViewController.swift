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
import MBProgressHUD

class ProfileViewController : UIViewController {
    
    enum TableRow: Int {
        case sounds
        case packs
    }
    
    enum DataState {
        case empty
        case loading
        case data(User)
    }
    
    // MARK: - Variables
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    var profileView = ProfileUserView(frame: .zero)
    
//    let profileView: ProfileUserView!
    
    // MARK: - Public Properties
    
    var user: User!
    
    var username = "me"
    
    // MARK: - Private Properties
    
    fileprivate let bag = DisposeBag()
    
    fileprivate let loader = SoundLoader()
    
    fileprivate var dataState = DataState.empty {
        didSet {
            updateWith(dataState)
        }
    }
    
    // MARK: - Constructors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataState = .loading
        loader.loadUser(withName: username, authRequired: true)
            .subscribe(onNext: ({ [weak self] user in
                guard let strongSelf = self else { return }
                strongSelf.user = user
                
                
                DispatchQueue.main.async {
                    strongSelf.dataState = .data(user)
//                    strongSelf.updateWith(user)
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
        
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            
            make.height.equalTo(256)
            make.bottom.equalTo(tableView.snp.top)
        }
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
    
    private func updateWith(_ user: User) {
        profileView.nameLabel.text = user.name
        profileView.avatarImageView.image = user.avatar
        profileView.homepageLabel.text = user.homepage
        profileView.joinedDateLabel.text = user.joinedDate
        
        tableView.reloadData()
    }
    
    private func updateWith(_ state: DataState) {
//        guard state == dataState else { return }
        
        switch state {
        case .empty:
            tableView.isHidden = true
            profileView.isHidden = true
            MBProgressHUD.hide(for: self.view, animated: true)
        case .loading:
            tableView.isHidden = true
            profileView.isHidden = true
            MBProgressHUD.showAdded(to: self.view, animated: true)
        case .data(let user):
            tableView.isHidden = false
            profileView.isHidden = false
            MBProgressHUD.hide(for: self.view, animated: true)
            
            profileView.nameLabel.text = user.name
            profileView.avatarImageView.image = user.avatar
            profileView.homepageLabel.text = user.homepage
            profileView.joinedDateLabel.text = user.joinedDate
            
            tableView.reloadData()
        default:
            break
        }
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
