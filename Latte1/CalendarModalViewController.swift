//
//  CalendarModalViewController.swift
//  Latte1
//
//  Created by sw_studio1 on 2019. 6. 11..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit

class CalendarModalViewController: UIViewController {

    @IBOutlet weak var DateLabel: UILabel!
    var datevalue: String!
    
    @IBAction func TouchCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TouchEnter(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DateLabel.text = datevalue
        // Do any additional setup after loading the view.
    }
    


}
