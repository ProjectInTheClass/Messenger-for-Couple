//
//  ConfirmViewController.swift
//  Latte1
//
//  Created by 이현지 on 10/06/2019.
//  Copyright © 2019 남혜빈. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController {
    
    @IBOutlet weak var confirm: UILabel!
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "confirmToauthdate", sender: self)
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "saved email")
        UserDefaults.standard.removeObject(forKey: "saved password")
        
        performSegue(withIdentifier: "confirmTologin", sender: self)
    }
    
    override func viewDidLoad() {
        confirm.text = "Are you " + Name + "?\n" + "and is your partner " + YourName + "?"
    
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
