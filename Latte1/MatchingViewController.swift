//
//  MatchingViewController.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 6. 13..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase

var myEmail: String = ""
var enteredEmail: String = ""

var myName: String = ""
var yourName: String = ""

class MatchingViewController: UIViewController {
    
    @IBOutlet weak var textfield: UITextField!
    
    @IBAction func startButton(_ sender: Any) {
        myEmail = FirebaseDataService.instance.currentUserEmail!
        myEmail = myEmail.replacingOccurrences(of: ".", with: "-")
        print("isMatched (myEmail: " + myEmail + ")")
        isMatched(myEmail: myEmail)
    }
    
    @IBAction func enterButton(_ sender: Any) {
        enteredEmail = textfield.text!
        myEmail = FirebaseDataService.instance.currentUserEmail!
        myEmail = myEmail.replacingOccurrences(of: ".", with: "-")
        enteredEmail = enteredEmail.replacingOccurrences(of: ".", with: "-")
        print("doMatching (myEmail: " + myEmail + ", yourEmail: " + enteredEmail + ")")
        doMatching(myEmail: myEmail, yourEmail: enteredEmail)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension MatchingViewController{
    func showAlert(message:String){
        let alert = UIAlertController(title: "매칭 에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isMatched(myEmail: String){
        var flag = false
        let nowUserRef = FirebaseDataService.instance.userRef.child(myEmail)
        nowUserRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let values = snapshot.value
            let dic = values as! Dictionary<String, String>
            
            for index in dic{
                if index.key == "groups" { //매칭되어있음
                    flag = true
                }
            }
        })
        if !flag{
            showAlert(message: "매칭이 되지 않았습니다. 상대방의 이메일을 입력하세요.")
        }
        else{
            // 매칭됨 -> 화면 이동
            performSegue(withIdentifier: "matchToconfirm", sender: self)
        }
    }
    
    func doMatching(myEmail: String, yourEmail: String){
        if textfield.text! == ""{
            showAlert(message: "이메일을 입력해주세요")
        }
        else{
            print("searching(myEmail: " + myEmail + ", yourEmail: " + yourEmail + ")")
            searching(myEmail: myEmail, yourEmail: yourEmail)
        }
    }
    //yourEmail이 user에 등록되어있는지 (가입했는지)
    func searching(myEmail: String, yourEmail: String) -> Void{
        let nowUserRef2 = FirebaseDataService.instance.userRef.child(myEmail)
        nowUserRef2.observeSingleEvent(of: .value, with: {(snapshot) in
            let values = snapshot.value
            let dic = values as! Dictionary<String, String>
            
            for index in dic{
                if index.key == "name"{
                    myName = index.value
                }
            }
        })
        let nowUserRef = FirebaseDataService.instance.userRef.child(yourEmail)
        nowUserRef.observeSingleEvent(of: .value, with: {(snapshot) in
            let values = snapshot.value
            if let dic = values as? Dictionary<String, String>{
                for index in dic{
                    if index.key == "name"{
                        yourName = index.value
                        //func matching()
                        let newGroupName = myEmail + yourEmail
                        FirebaseDataService.instance.userRef.child(myEmail).child("groups").updateChildValues(["groupname":newGroupName])
                        FirebaseDataService.instance.userRef.child(myEmail).child("groups").updateChildValues(["name":yourName])
                        FirebaseDataService.instance.userRef.child(myEmail).child("groups").updateChildValues(["myname":myName])
                        FirebaseDataService.instance.userRef.child(myEmail).child("groups").updateChildValues(["email":yourEmail])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("groups").updateChildValues(["groupname":newGroupName])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("groups").updateChildValues(["name":myName])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("groups").updateChildValues(["myname":yourName])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("groups").updateChildValues(["email":myEmail])
                        FirebaseDataService.instance.userRef.child(myEmail).child("realloveday").updateChildValues(["monday":"false"])
                        FirebaseDataService.instance.userRef.child(myEmail).child("realloveday").updateChildValues(["tuesday":"false"])
                        FirebaseDataService.instance.userRef.child(myEmail).child("realloveday").updateChildValues(["wednesday":"false"])
                        FirebaseDataService.instance.userRef.child(myEmail).child("realloveday").updateChildValues(["thursday":"false"])
                        FirebaseDataService.instance.userRef.child(myEmail).child("realloveday").updateChildValues(["friday":"false"])
                        FirebaseDataService.instance.userRef.child(myEmail).child("realloveday").updateChildValues(["saturday":"false"])
                        FirebaseDataService.instance.userRef.child(myEmail).child("realloveday").updateChildValues(["sunday":"false"])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("realloveday").updateChildValues(["monday":"false"])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("realloveday").updateChildValues(["tuesday":"false"])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("realloveday").updateChildValues(["wednesday":"false"])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("realloveday").updateChildValues(["thursday":"false"])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("realloveday").updateChildValues(["friday":"false"])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("realloveday").updateChildValues(["saturday":"false"])
                        FirebaseDataService.instance.userRef.child(yourEmail).child("realloveday").updateChildValues(["sunday":"false"])
                        self.performSegue(withIdentifier: "matchToconfirm", sender: self)
                        return
                    }
                }
            }
            else{
                self.showAlert(message: "없는 이메일입니다")
                nowUserRef.removeValue()
                return
            }
        })
    }
}

