//
//  Chat2ViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 6. 14..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
class Chat2MessageCell : UITableViewCell {
    
    @IBOutlet weak var messageImage2: UIImageView!
    @IBOutlet weak var textLabel2: UILabel!
}

class Chat2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var messages: [ChatMessage] = []
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chat2Cell", for: indexPath) as! Chat2MessageCell
        let message = messages[indexPath.item]
        print(message.text)
        cell.textLabel2.text! = message.text
        
        setupChatCell(cell: cell, message: message)
        //if message.text.characters.count > 0 {
        //    cell.sizeThatFits(measuredFrameHeightForEachMessage(message: message.text).size)
        //    cell.messageImage2.sizeThatFits(measuredFrameHeightForEachMessage(message: message.text).size
        //}
        //print(cell.textLabel2.text)
        cell.selectionStyle = .none
        return cell
    }
    

    
    func setupChatCell(cell: Chat2MessageCell, message: ChatMessage) {
        if message.fromUserId == FirebaseDataService.instance.currentUserEmail?.replacingOccurrences(of: ".", with: "-") {
            cell.messageImage2.image = UIImage(named: "Me")
            cell.messageImage2.autoresizingMask = UIView.AutoresizingMask.flexibleLeftMargin
            //cell.containerView.backgroundColor = UIColor.magenta
            cell.textLabel2.textColor = UIColor.black
            //let size = UIEdgeInsets.init(top: self.chat2.rowHeight/2, left: 1, bottom: self.chat2.rowHeight/2, right: 30)
            //cell.messageImage2.image?.resizableImage(withCapInsets: size, resizingMode: .stretch)
            
            var labelWidth = CGFloat(message.text.count * 13)
            if message.text.count * 13 > Int(cell.frame.width * 2 / 3) {
                labelWidth = CGFloat(cell.frame.width * 2/3)
            }
            cell.messageImage2.frame = CGRect.init(x: cell.frame.maxX-labelWidth, y: cell.frame.minY, width: labelWidth, height: cell.frame.height-10)
            //cell.messageImage2.frame = CGRectMake(320.0-(size.width+35.0), 2.0, size.width+35.0, size.height+24.0);
            cell.messageImage2.autoresizingMask = UIView.AutoresizingMask.flexibleLeftMargin;
            cell.textLabel2.frame = CGRect.init(x: cell.frame.maxX-cell.messageImage2.frame.width, y: cell.frame.minY, width: cell.messageImage2.frame.width, height: cell.frame.height-10.0)
            cell.textLabel2.autoresizingMask = UIView.AutoresizingMask.flexibleLeftMargin;
            //cell.containerViewRightAnchor?.isActive = true
            //cell.containerViewLeftAnchor?.isActive = false
        } else {
            var labelWidth = CGFloat(message.text.count * 13)
            if message.text.count * 13 > Int(cell.frame.width * 2 / 3) {
                labelWidth = CGFloat(cell.frame.width * 2/3)
            }
            //cell.containerView.backgroundColor = UIColor.lightGray
            cell.messageImage2.image = UIImage(named: "You")
            cell.messageImage2.autoresizingMask = UIView.AutoresizingMask.flexibleRightMargin
            
            cell.textLabel2.textColor = UIColor.black
            cell.textLabel2.frame = CGRect.init(x: cell.frame.minX, y: cell.frame.minY, width: labelWidth, height: cell.frame.height - 10.0)
            cell.messageImage2.frame = CGRect.init(x: cell.frame.minX, y: cell.frame.minY, width: cell.textLabel2.frame.width, height: cell.frame.height-10)
            //cell.containerViewRightAnchor?.isActive = false
            //cell.containerViewLeftAnchor?.isActive = true
            cell.textLabel2.autoresizingMask = UIView.AutoresizingMask.flexibleRightMargin
        }
    }
    
    private func measuredFrameHeightForEachMessage(message: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: message).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    @IBOutlet weak var chat2: UITableView!
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var item: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chat2.estimatedRowHeight = 168.0
        
        self.chat2.rowHeight = UITableView.automaticDimension
        
        
        
        fetchChatGroupList()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //chat2.reloadData()
    }
    
    func fetchChatGroupList() {
        if let uid = FirebaseDataService.instance.currentUserEmail?.replacingOccurrences(of: ".", with: "-") {
            
            FirebaseDataService.instance.userRef.child(uid).child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dict = snapshot.value as? Dictionary<String, String> {
                    for (key, _) in dict {
                        if key == "groupname" {
                            self.groupKey = dict[key]
                        }
                        //FirebaseDataService.instance.groupRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                            /*print(snapshot)
                             if let data = snapshot.value as? Dictionary<String, AnyObject> {
                             let group = Group(key: key, data: data)
                             self.groupKey = group.key
                             print(group.key)
                             DispatchQueue.main.async(execute: {
                             
                             })
                             }*/
                            
                        //})
                    }
                }
            })
        }
    }
    var groupKey: String? {
        didSet {
            if let key = groupKey {
                fetchMessages()
                FirebaseDataService.instance.userRef.child(FirebaseDataService.instance.currentUserEmail!.replacingOccurrences(of: ".", with: "-")).child("groups").child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let data = snapshot.value as? String {
                        
                        if let title = data as? String {
                            print(title)
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
//                    self.messages.insert(message, at: self.messages.count )
                    self.messages.append(message)
//                    self.chat2.reloadData()
                    let index = IndexPath(row: self.messages.count-1, section: 0)
                    self.chat2.insertRows(at: [index], with: .automatic)
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
        chatTextField.text = chatTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if chatTextField.text != "" {
        let ref = FirebaseDataService.instance.messageRef.childByAutoId()
        guard let fromUserId = FirebaseDataService.instance.currentUserEmail?.replacingOccurrences(of: ".", with: "-") else {
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
            
        }
        //self.fetchMessages()
    }
    @IBAction func tableViewTapped(_ sender: Any) {
        chatTextField.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
