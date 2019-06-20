//
//  AuthViewController.swift
//  Latte1
//
//  Created by 이현지 on 09/06/2019.
//  Copyright © 2019 남혜빈. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func unwind3(_ sender: UIStoryboardSegue){}
    
    @IBAction func AuthButton(_ sender: Any) {
        doSignUp()
        //performSegue(withIdentifier: "matching", sender: self)
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "authToauthdate", sender: self)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        performSegue(withIdentifier: "authTologin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension AuthViewController{
    func showAlert(message:String){
        let alert = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func doSignUp(){
        if nameField.text! == ""{
            showAlert(message: "이름을 입력해주세요")
            return
        }
        if emailField.text! == ""{
            showAlert(message: "이메일을 입력해주세요")
            return
        }
        if passwordField.text! == ""{
            showAlert(message: "비밀번호를 입력해주세요")
            return
        }
        Name = nameField.text!
        Email = emailField.text!
        Password = passwordField.text!
        
        signUp(email: emailField.text!, password: passwordField.text!)
        print("success register")
    }
    
    func signUp(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password, completion: {
            (user, error) in
            if error != nil{
                if let ErrorCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch ErrorCode {
                    case AuthErrorCode.invalidEmail:
                        self.showAlert(message: "유효하지 않은 이메일 입니다")
                        print("유효하지 않은 이메일 입니다")
                    case AuthErrorCode.emailAlreadyInUse:
                        self.showAlert(message: "이미 가입한 회원 입니다")
                        print("이미 가입한 회원 입니다")
                    case AuthErrorCode.weakPassword:
                        self.showAlert(message: "비밀번호는 6자리 이상이어야 합니다")
                        print("비밀번호는 6자리 이상이어야 합니다")
                    default:
                        print(ErrorCode)
                    }
                }
            } else{
                print(email.replacingOccurrences(of: ".", with: "-"))
                FirebaseDataService.instance.userRef.child(email.replacingOccurrences(of: ".", with: "-")).updateChildValues(["name":Name])
                FirebaseDataService.instance.userRef.child(email.replacingOccurrences(of: ".", with: "-")).updateChildValues(["email":email.replacingOccurrences(of: ".", with: "-")])
                FirebaseDataService.instance.userRef.child(email.replacingOccurrences(of: ".", with: "-")).updateChildValues(["password":password])
                FirebaseDataService.instance.userRef.child(email.replacingOccurrences(of: ".", with: "-")).updateChildValues(["birthday":myBirthDate])
                FirebaseDataService.instance.userRef.child(email.replacingOccurrences(of: ".", with: "-")).updateChildValues(["loveday":ourLoveDate])
                FirebaseDataService.instance.userRef.child(email.replacingOccurrences(of: ".", with: "-")).updateChildValues(["uid":FirebaseDataService.instance.currentUserUid!])
                
                print("회원가입 성공")
                dump(user)
                self.performSegue(withIdentifier: "matching", sender: self)
            }
        })
    }
}
