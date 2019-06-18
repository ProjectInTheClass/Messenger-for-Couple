//
//  AddSchedViewController.swift
//  Latte1
//
//  Created by sw_studio1 on 2019. 6. 11..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddSchedViewController: UIViewController {
    var datevalue : String!
    var schedstring : String!
    var rootRef : DatabaseReference!
    var curruseruid : String!
    @IBOutlet weak var DateLabel: UILabel!
    
    @IBOutlet weak var SchedText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 일정을 추가할 날짜를 Label로 보여주기
        DateLabel.text = datevalue
        
        rootRef = Database.database().reference()
        curruseruid = Auth.auth().currentUser?.uid
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func TouchCancel(_ sender: Any) {
        // 취소버튼을 누르면 그냥 이전 페이지로 되돌아감
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TouchComplete(_ sender: Any) {
        // 완료버튼을 누르면 후에 데이터베이스에 일정 추가
        // text Label에 아무것도 입력된것이 아닌걸 제외하고는 일정 추가하도록 설정.
        
        if(SchedText.text != nil){
            schedstring = SchedText!.text
            print(schedstring)
            //데이터베이스의 schedule 서브 트리의 해당 날짜에 사용자 id 의 데이터로 일정(String) 한개 추가
            //"schedule" : 일정이 저장되어 있는 서브트리 명
            // datevalue : 위의 서브트리에서 추가하려는 날짜의 서브트리로 이동하여 일정 저장.ㄴ
            
            // 데이터베이스에 잘 추가되는지 확인해보기 -> 날짜 및 uid 별로 잘 추가된다.
            rootRef.child("schedule").child(datevalue).child(curruseruid).childByAutoId().setValue(schedstring)
            
        }
        // 이전 화면으로 되돌아 가기.
        dismiss(animated: true, completion: nil)
    }
    
}
