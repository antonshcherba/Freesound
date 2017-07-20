//
//  CommentsController.swift
//  FreeSound
//
//  Created by chiuser on 7/19/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//

import UIKit
import ALTextInputBar

class CommentsController: UITableViewController {

    let soundService = FreesoundService()
    
    var soundInfo: SoundInfo!
    
    var comments:[Comment] = []
    
    var dateFormatter: DateFormatter!
    
    var commentInputView = ALTextInputBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupData()
        
        soundService.getCommentsFor(soundInfo) { [weak self] (comments) in
            guard let strongSelf = self else { return }
            strongSelf.comments = comments
            
            strongSelf.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupView() {
        setupTableView()
        setupInputView()
    }
    
    func setupInputView() {
        commentInputView.alwaysShowRightButton = true
        
        let sendButton = UIButton(type: .custom)
        sendButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        sendButton.setImage(UIImage(named: "SearchOptionOnButton"), for: .normal)
        
        sendButton.addTarget(self, action: #selector(sendCommentButtonTapped(_:)), for: .touchUpInside)
        commentInputView.rightView = sendButton
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return commentInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
    }
    
    func setupData() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
    }
    
    func sendCommentButtonTapped(_ sender: UIButton) {
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
        let comment = comments[indexPath.row]
        
        cell.usernameLabel.text = comment.user?.name
        cell.dateTimeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: comment.created))
        cell.commentLabel.text = comment.text
        
        cell.setNeedsUpdateConstraints()
        cell.updateConstraints()
        
        return cell
    }
}
