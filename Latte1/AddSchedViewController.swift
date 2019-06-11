//
//  AddSchedViewController.swift
//  Latte1
//
//  Created by sw_studio1 on 2019. 6. 11..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit

class AddSchedViewController: UIViewController {
    var datevalue : String!
    var schedstring : String!
    @IBOutlet weak var DateLabel: UILabel!
    
    @IBOutlet weak var SchedText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 일정을 추가할 날짜를 Label로 보여주기
        DateLabel.text = datevalue
        // Do any additional setup after loading the view.
    }
    

    @IBAction func TouchCancel(_ sender: Any) {
        // 취소버튼을 누르면 그냥 이전 페이지로 되돌아감
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TouchComplete(_ sender: Any) {
        // 완료버튼을 누르면 후에 데이터베이스에 일정 추가
        schedstring = SchedText.text
        print(schedstring)
        dismiss(animated: true, completion: nil)
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
