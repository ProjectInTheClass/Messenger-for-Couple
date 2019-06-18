//
//  AuthDateViewController.swift
//  Latte1
//
//  Created by 이현지 on 10/06/2019.
//  Copyright © 2019 남혜빈. All rights reserved.
//

import UIKit

class AuthDateViewController: UIViewController {
    
    @IBAction func unwind2(_ sender: UIStoryboardSegue){}
    
    @IBAction func cancelButton(_ sender: UIButton) {
        performSegue(withIdentifier: "authdateTologin", sender: self)
    }
    
    @IBOutlet weak var birthday: UIDatePicker!
    @IBOutlet weak var loveday: UIDatePicker!
    
    @IBAction func pickBirthday(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        myBirthDate = formatter.string(from: birthday.date)
        print("birthday: " + myBirthDate)
    }
    
    @IBAction func pickLoveday(_ sender: Any) {
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "yyyy-MM-dd"
        
        ourLoveDate = formatter2.string(from: loveday.date)
        print("loveday: " + ourLoveDate)
    }
    
    override func viewDidLoad() {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        myBirthDate = formatter.string(from: today)
        ourLoveDate = formatter.string(from: today)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
