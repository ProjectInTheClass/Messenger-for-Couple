//
//  LoadingViewController.swift
//  Latte1
//
//  Created by 이현지 on 10/06/2019.
//  Copyright © 2019 남혜빈. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        
        if let alreadySignedIn = Auth.auth().currentUser {
            // segue to main view controller
            performSegue(withIdentifier: "loadingToconfirm", sender: self)
            print("loading to confirm")
        } else {
            // sign in
            performSegue(withIdentifier: "loadingTologin", sender: self)
            print("loading to login")
        }
        /*22222
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in.
                self.performSegue(withIdentifier: "loadingToconfirm", sender: self)
            } else {
                // No user is signed in.
                self.performSegue(withIdentifier: "loadingTologin", sender: self)
            }
        }
        */
        /*33333
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "loadingToconfirm", sender: self)
            print("loading to main")
        }
        else{
            performSegue(withIdentifier: "loadingTologin", sender: self)
            print("loading to login")
        }*/
        /*44444
        if let userId = UserDefaults.standard.string(forKey: "saved email"){
            getUserData { (success, response, error) in
                dologin(success: success, response: response, error: error)
            }
        }*/
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
