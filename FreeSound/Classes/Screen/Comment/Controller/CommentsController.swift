//
//  CommentsController.swift
//  FreeSound
//
//  Created by Anton Shcherba on 7/19/17.
//  Copyright © 2017 Anton Shcherba. All rights reserved.
//

import UIKit
import ALTextInputBar
import MessageKit

class CommentsController: MessagesViewController {

    let soundService = FreesoundService()
    
    var soundInfo: SoundInfo!
    
    var comments:[CommentCoreData] = []
    
    var dateFormatter: DateFormatter!
    
    var commentInputView = ALTextInputBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupData()
        
        soundService.getCommentsFor(soundInfo) { [weak self] (comments) in
            guard let strongSelf = self else { return }
            strongSelf.comments = comments
            
            strongSelf.messagesCollectionView.reloadData()
//            strongSelf.tableView.reloadData()
        }
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
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
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 80
//
//        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
    }
    
    func setupData() {
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
    }
    
    func sendCommentButtonTapped(_ sender: UIButton) {
    }

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return comments.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
//        let comment = comments[indexPath.row]
//
//        cell.usernameLabel.text = comment.user?.name
//        cell.dateTimeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: comment.created))
//        cell.commentLabel.text = comment.text
//
//        cell.setNeedsUpdateConstraints()
//        cell.updateConstraints()
//
//        return cell
//    }
}

extension CommentsController: MessagesLayoutDelegate {
    
    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        if isFromCurrentSender(message: message) {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
        }
    }
    
    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        } else {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        }
    }
    
    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        } else {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }
    }
    
    func avatarAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarAlignment {
        return .messageBottom
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: messagesCollectionView.bounds.width, height: 10)
    }
    
}

extension CommentsController: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
        //        let configurationClosure = { (view: MessageContainerView) in}
        //        return .custom(configurationClosure)
    }
    
}

extension CommentsController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return Sender(id: "777777", displayName: "Toni")
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return comments.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let comment = comments[indexPath.section]
        let sender = Sender(id: comment.user!.name, displayName: comment.user!.name)
        let message = MockMessage(text: comment.text!, sender: sender, messageId: "\(comment.created)", date: Date.init(timeIntervalSince1970: comment.created))
        
        return message
    }
    
//    func avatar(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Avatar {
//        return SampleData.shared.getAvatarFor(sender: message.sender)
//    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let name = message.sender.displayName
//        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        let dateString = formatter.string(from: message.sentDate)
//        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
        return nil
    }
    
}


struct MockMessage: MessageType {
    
    var messageId: String
    var sender: Sender
    var sentDate: Date
    var data: MessageData
    
    init(data: MessageData, sender: Sender, messageId: String, date: Date) {
        self.data = data
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(data: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(data: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }
    
    init(image: UIImage, sender: Sender, messageId: String, date: Date) {
        self.init(data: .photo(image), sender: sender, messageId: messageId, date: date)
    }
    
    init(thumbnail: UIImage, sender: Sender, messageId: String, date: Date) {
        let url = URL(fileURLWithPath: "")
        self.init(data: .video(file: url, thumbnail: thumbnail), sender: sender, messageId: messageId, date: date)
    }
    
    init(emoji: String, sender: Sender, messageId: String, date: Date) {
        self.init(data: .emoji(emoji), sender: sender, messageId: messageId, date: date)
    }
    
}

