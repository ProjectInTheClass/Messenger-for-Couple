//
//  ChatViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 6. 12..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
import Firebase

class ChatMessageCell: UICollectionViewCell {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    
    /*var containerViewWidthAnchor: NSLayoutConstraint?
    var containerViewRightAnchor: NSLayoutConstraint?
    var containerViewLeftAnchor: NSLayoutConstraint?
    var containerViewHeightAnchor: NSLayoutConstraint?
    var textLabelHeightAnchor: NSLayoutConstraint?
    
    func setUITraits() {
        containerView.layer.cornerRadius = 4
        
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
    }
    
    func setAnchors() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        containerViewLeftAnchor = containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4)
        containerViewRightAnchor = containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4)
        containerViewWidthAnchor = containerView.widthAnchor.constraint(equalToConstant: 200)
        containerViewHeightAnchor = containerView.heightAnchor.constraint(equalToConstant: frame.height)
        containerViewWidthAnchor?.isActive = true
        containerViewHeightAnchor?.isActive = true
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        textLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 4).isActive = true
        textLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        textLabelHeightAnchor = textLabel.heightAnchor.constraint(equalToConstant: frame.height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setAnchors()
        setUITraits()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func measuredFrameHeightForEachMessage(message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        let height = measuredFrameHeightForEachMessage(message: textLabel.text!).height + 20
        var newFrame = layoutAttributes.frame
        newFrame.size.width = CGFloat(ceilf(Float(size.width)))
        newFrame.size.height = height
        containerViewHeightAnchor?.constant = height
        textLabelHeightAnchor?.constant = height
        layoutAttributes.frame = newFrame
        return layoutAttributes
    }*/
}

class ChatViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var messages: [ChatMessage] = []
  
    
    @IBOutlet weak var start: UILabel!
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if messages.count == 0 {
            start.isEnabled = true
        }
        
        else {
            start.isEnabled = false
        }
        
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
    
        cell.textLabel.text! = message.text

        setupChatCell(cell: cell, message: message)
        if message.text.characters.count > 0 {
            cell.sizeThatFits(measuredFrameHeightForEachMessage(message: message.text).size)
            cell.messageImage.sizeThatFits(measuredFrameHeightForEachMessage(message: message.text).size)
        }
        print(cell.textLabel.text)
        return cell
    }
    
    func setupChatCell(cell: ChatMessageCell, message: ChatMessage) {
        if message.fromUserId == FirebaseDataService.instance.currentUserUid {
            cell.messageImage.image = UIImage(named: "Me")
            cell.messageImage.autoresizingMask = UIView.AutoresizingMask.flexibleLeftMargin
            //cell.containerView.backgroundColor = UIColor.magenta
            cell.textLabel.textColor = UIColor.black
            //cell.containerViewRightAnchor?.isActive = true
            //cell.containerViewLeftAnchor?.isActive = false
        } else {
            //cell.containerView.backgroundColor = UIColor.lightGray
            cell.messageImage.image = UIImage(named: "You")
            cell.messageImage.autoresizingMask = UIView.AutoresizingMask.flexibleRightMargin
            cell.textLabel.textColor = UIColor.black
            //cell.containerViewRightAnchor?.isActive = false
            //cell.containerViewLeftAnchor?.isActive = true
        }
    }
    
    private func measuredFrameHeightForEachMessage(message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var item: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchChatGroupList()
        // Do any additional setup after loading the view.
    }
    
    func fetchChatGroupList() {
        if let uid = FirebaseDataService.instance.currentUserUid {
            
            FirebaseDataService.instance.userRef.child(uid).child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dict = snapshot.value as? Dictionary<String, String> {
                    for (key, _) in dict {
                        if key == "with" {
                            continue
                        }
                        FirebaseDataService.instance.groupRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                            /*print(snapshot)
                            if let data = snapshot.value as? Dictionary<String, AnyObject> {
                                let group = Group(key: key, data: data)
                                self.groupKey = group.key
                                print(group.key)
                                DispatchQueue.main.async(execute: {
                                    
                                })
                            }*/
                            self.groupKey = snapshot.key
                        })
                }
                }
            })
        }
    }
    var groupKey: String? {
        didSet {
            if let key = groupKey {
                fetchMessages()
                FirebaseDataService.instance.userRef.child(FirebaseDataService.instance.currentUserUid!).child("groups").child("with").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let data = snapshot.value as? String {
                        
                        if let title = data as? String {
                            self.item.text = title
                        }
                    }
                })
            }
        }
    }
    
    
    func fetchMessages() {
        if let groupId = self.groupKey {
            let groupMessageRef = FirebaseDataService.instance.groupRef.child(groupId).child("messages")
            groupMessageRef.observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
              
                let messageRef = FirebaseDataService.instance.messageRef.child(messageId)
                messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let dict = snapshot.value as? Dictionary<String, AnyObject> else {
                        return
                    }
                    let message = ChatMessage(
                        fromUserId: dict["fromUserId"] as! String,
                        text: dict["text"] as! String,
                        timestamp: dict["timestamp"] as! NSNumber
                    )
                    self.messages.insert(message, at: self.messages.count )
                    
                    self.chatCollectionView.reloadData()
                    if self.messages.count >= 1 {
                        let indexPath = IndexPath(item: self.messages.count , section: 0)
                        //self.chatCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
                    }
                })
            })
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sendButton(_ sender: Any) {
        let ref = FirebaseDataService.instance.messageRef.childByAutoId()
        guard let fromUserId = FirebaseDataService.instance.currentUserUid else {
            return
        }
        
        let data: Dictionary<String, AnyObject> = [
            "fromUserId": fromUserId as AnyObject,
            "text": chatTextField.text! as AnyObject,
            "timestamp": NSNumber(value: Date().timeIntervalSince1970)
        ]
        ref.updateChildValues(data) { (err, ref) in
            guard err == nil else {
                print(err as Any)
                return
            }
            
            self.chatTextField.text = nil
           
            if let groupId = self.groupKey {
                FirebaseDataService.instance.groupRef.child(groupId).child("messages").child(ref.key!).updateChildValues(data)
                
                
            }
        }
        //self.fetchMessages()
    }
    @IBAction func collectionViewTapped(_ sender: Any) {
        chatTextField.resignFirstResponder()
    }
}
