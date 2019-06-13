//
//  MatchingViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 6. 13..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
import FirebaseAuth

class MatchingViewController: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    @IBAction func startButton(_ sender: Any) {
    }
    @IBAction func enterButton(_ sender: Any) {
        if textfield.text == nil {
            
        }
        else {
            let other = textfield.text!.replacingOccurrences(of: ".", with: "-")
            let user = FirebaseDataService.instance.userRef.observeSingleEvent(of: .value, with: {(snapshot) in
                
                if let uid = snapshot.value as? Dictionary<String, AnyObject> {
                    for (key, _) in uid {
                        let info = FirebaseDataService.instance.userRef.child(key).observeSingleEvent(of: .value, with: {(snapshots) in
                            
                            print(snapshots.value)
                        })
                        //let info = FirebaseDataService.instance.userRef.child(key).value(forKey: "email")
                        //print(info)
                        /*if info ==  other{
                            
                        }*/
                    }
                }
            })
            print(FirebaseDataService.instance.userRef.queryEqual(toValue: textfield.text!))
        }
    }
    override func viewDidLoad() {
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
