//
//  RemoveSchedViewController.swift
//  Latte1
//
//  Created by sw_studio1 on 2019. 6. 19..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RemoveSchedViewController: UIViewController {
    var datevalue : String!
    var schedstring : String!
    var rootRef : DatabaseReference!
    var curruseruid : String!
    
    @IBOutlet weak var DateLabel: UILabel!
    
    @IBOutlet weak var SchedText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DateLabel.text = datevalue
        print(datevalue)
        rootRef = Database.database().reference()
        curruseruid = Auth.auth().currentUser?.email?.replacingOccurrences(of: ".", with: "-")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func TouchComplete(_ sender: Any) {
        if(SchedText.text != nil){
            schedstring = SchedText!.text
            print(schedstring)
            //데이터베이스의 schedule 서브 트리의 해당 날짜에 사용자 id 의 데이터로 일정(String) 한개 추가
            //"schedule" : 일정이 저장되어 있는 서브트리 명
            // datevalue : 위의 서브트리에서 추가하려는 날짜의 서브트리로 이동하여 일정 저장.ㄴ
            
            // 데이터베이스에 잘 추가되는지 확인해보기 -> 날짜 및 uid 별로 잘 추가된다.
            //rootRef.child("schedule").child(datevalue).child(curruseruid).childByAutoId().setValue(schedstring)
            rootRef.child("schedule").child(datevalue).child(curruseruid).observeSingleEvent(of: .value) { (snapshot) in
                let snapchild = snapshot.children
                while let rest = snapchild.nextObject() as? DataSnapshot{
                    let input = rest.value as! String
                    if input == self.schedstring{
                        let dataid = rest.key
                        self.rootRef.child("schedule").child(self.datevalue).child(self.curruseruid).child(dataid).removeValue()
                    }
                }
            }
        }
        rootRef.child("user").child(self.curruseruid).child("groups").child("email").observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value {
                let matchid = data as? String
                //print(matchid)
                self.rootRef.child("schedule").child(self.datevalue).child("\(String(describing: matchid!))").observeSingleEvent(of: .value, with: { (snapshot) in
                    let snapchild = snapshot.children
                    while let rest = snapchild.nextObject() as? DataSnapshot{
                        let input = rest.value as! String
                        if input == self.schedstring{
                            let dataid = rest.key
                            self.rootRef.child("schedule").child(self.datevalue).child("\(String(describing: matchid!))").child(dataid).removeValue()
                        }
                    }
                    
                })
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func TouchCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
