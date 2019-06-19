//
//  LoginViewController.swift
//  Latte1
//
//  Created by 이현지 on 09/06/2019.
//  Copyright © 2019 남혜빈. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func unwind(_ sender: UIStoryboardSegue){}
    
    @IBAction func loginButton(_ sender: UIButton) {
        dologin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

extension LoginViewController{
    func showAlert(message:String){
        let alert = UIAlertController(title: "로그인 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func dologin(){
        if emailField.text! == ""{
            showAlert(message: "이메일을 입력해주세요")
            return
        }
        
        if passwordField.text! == ""{
            showAlert(message: "비밀번호를 입력해주세요")
            return
        }
        login(email: emailField.text!, password: passwordField.text!)
    }
    
    func login(email: String, password: String){
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        Email = email
        Password = password
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                // TODO: 로그인 성공 user 객체에서 정보 사용
                print("login success")
                let nowSchedRef = FirebaseDataService.instance.userRef.child(Email.replacingOccurrences(of: ".", with: "-")).child("groups")
                nowSchedRef.observeSingleEvent(of: .value, with: {(snapshot) in
                    let values = snapshot.value
                    let dic = values as! Dictionary<String, String>
                    
                    for index in dic{
                        if index.key == "myname"{
                            Name = index.value
                        }
                        if index.key == "name"{
                            YourName = index.value
                        }
                    }
                    self.performSegue(withIdentifier: "loginToconfirm", sender: self)
                })
            } else {
                // TODO: 로그인 실패 처리
                if let ErrorCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch ErrorCode {
                    case AuthErrorCode.userNotFound:
                        self.showAlert(message: "user not found")
                    case AuthErrorCode.wrongPassword:
                        self.showAlert(message: "wrong password")
                    default:
                        print(ErrorCode)
                    }
                }
                print("login fail")
            }
        }
    }
}
