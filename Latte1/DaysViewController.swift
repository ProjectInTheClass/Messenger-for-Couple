//
//  DaysViewController.swift
//  Latte1
//
//  Created by 이현지 on 03/06/2019.
//  Copyright © 2019 남혜빈. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase

var MyEmail: String = ""
var yourEmail: String = ""

class DaysViewController: UIViewController {
    @IBOutlet weak var Auth: UILabel!
    
    @IBOutlet weak var RealDays: UILabel!
    @IBOutlet weak var UpperText: UILabel!
    @IBOutlet weak var BottomText: UILabel!
    
    @IBOutlet weak var LeadText: UILabel!
    
    @IBOutlet weak var WaitingImage: UIImageView!
    
    @IBAction func Select(_ sender: Any) {
        setNow()
        
        if(((nowHour >= 0 && nowHour < 3) || (nowHour >= 21 && nowHour < 24)) && selected[numWeekday-1] == false){
            let chooseAlert = UIAlertController(title: "Make your mind", message: "do you love her/him?", preferredStyle: .alert)
            let LoveAction = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) -> Void in self.SelectYes()})
            let NoAction = UIAlertAction(title: "No", style: .default, handler: {(action: UIAlertAction) -> Void in self.SelectNo()})
            
            chooseAlert.addAction(LoveAction)
            chooseAlert.addAction(NoAction)
            
            self.present(chooseAlert, animated: true, completion: nil)
        }
        else if(selected[numWeekday-1] == true){
            let chooseAlert = UIAlertController(title: "You already did", message: "Please try again tomorrow", preferredStyle: .alert)
            let checkAction = UIAlertAction(title: "Okay", style: .default, handler: {(action: UIAlertAction) -> Void in print()})
            
            chooseAlert.addAction(checkAction)
            
            self.present(chooseAlert, animated: true, completion: nil)
        }
        else{
            let chooseAlert = UIAlertController(title: "You cannot access now", message: "Please try again from 21:00 to 03:00", preferredStyle: .alert)
            let checkAction = UIAlertAction(title: "Okay", style: .default, handler: {(action: UIAlertAction) -> Void in print()})
            
            chooseAlert.addAction(checkAction)
            
            self.present(chooseAlert, animated: true, completion: nil)
        }
    }
    
    func SelectYes(){
        MyEmail = FirebaseDataService.instance.currentUserEmail!
        MyEmail = MyEmail.replacingOccurrences(of: ".", with: "-")
        print("SelectYes: " + MyEmail)
        
        if nowWeekday == WeekDay.Sun{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["sunday":"true"])
        }
        if nowWeekday == WeekDay.Mon{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["monday":"true"])
        }
        if nowWeekday == WeekDay.Tue{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["tuesday":"true"])
        }
        if nowWeekday == WeekDay.Wed{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["wednesday":"true"])
        }
        if nowWeekday == WeekDay.Thu{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["thursday":"true"])
        }
        if nowWeekday == WeekDay.Fri{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["friday":"true"])
        }
        if nowWeekday == WeekDay.Sat{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["saturday":"true"])
        }
        selected[numWeekday-1] = true
        
        Change()
    }
    
    func SelectNo(){
        MyEmail = FirebaseDataService.instance.currentUserEmail!
        MyEmail = MyEmail.replacingOccurrences(of: ".", with: "-")
        print("SelectNo: " + MyEmail)
        
        if nowWeekday == WeekDay.Sun{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["sunday":"false"])
        }
        if nowWeekday == WeekDay.Mon{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["monday":"false"])
        }
        if nowWeekday == WeekDay.Tue{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["tuesday":"false"])
        }
        if nowWeekday == WeekDay.Wed{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["wednesday":"false"])
        }
        if nowWeekday == WeekDay.Thu{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["thursday":"false"])
        }
        if nowWeekday == WeekDay.Fri{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["friday":"false"])
        }
        if nowWeekday == WeekDay.Sat{
            FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday").updateChildValues(["saturday":"false"])
        }
        selected[numWeekday-1] = true
        
        Change()
    }
    
    func rotate(imageView: UIImageView, aCircleTime: Double) { //CABasicAnimation
        print("/rotate")
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = aCircleTime
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: nil)
        print("rotate/")
    }
    
    func Calcul(){
        print("/Calcul")
        MyEmail = FirebaseDataService.instance.currentUserEmail!
        MyEmail = MyEmail.replacingOccurrences(of: ".", with: "-")
        
        print("1")
        //yourEmail = FirebaseDataService.instance.userRef.child(MyEmail).child("groups").value(forKey: "email") as! String
        let nowUserRef = FirebaseDataService.instance.userRef.child(MyEmail).child("groups")
        nowUserRef.observeSingleEvent(of: .value, with: {(snapshot) in
            print("1-1")
            let values = snapshot.value
            let dic = values as! Dictionary<String, String>
            for index in dic{
                print(index.key + " " + index.value)
                if index.key == "email"{
                    yourEmail = index.value
                    yourEmail = yourEmail.replacingOccurrences(of: ".", with: "-")
                    print("YOUR EMAIL: " + yourEmail)
                }
            }
        })
        print("2")
        let nowUserRef2 = FirebaseDataService.instance.userRef.child(MyEmail).child("realloveday")
        nowUserRef2.observeSingleEvent(of: .value, with: {(snapshot) in
            print("2-1")
            let values = snapshot.value
            let dic = values as! Dictionary<String, String>
            
            for index in dic{
                if index.key == "sunday"{
                    if index.value == "true"{
                        myLoveDay[0] = true
                    }
                    else{
                        myLoveDay[0] = false
                    }
                }
                if index.key == "monday"{
                    if index.value == "true"{
                        myLoveDay[1] = true
                    }
                    else{
                        myLoveDay[1] = false
                    }
                }
                if index.key == "tuesday"{
                    if index.value == "true"{
                        myLoveDay[2] = true
                    }
                    else{
                        myLoveDay[2] = false
                    }
                }
                if index.key == "wednesday"{
                    if index.value == "true"{
                        myLoveDay[3] = true
                    }
                    else{
                        myLoveDay[3] = false
                    }
                }
                if index.key == "thursday"{
                    if index.value == "true"{
                        myLoveDay[4] = true
                    }
                    else{
                        myLoveDay[4] = false
                    }
                }
                if index.key == "friday"{
                    if index.value == "true"{
                        myLoveDay[5] = true
                    }
                    else{
                        myLoveDay[5] = false
                    }
                }
                if index.key == "saturday"{
                    if index.value == "true"{
                        myLoveDay[6] = true
                    }
                    else{
                        myLoveDay[6] = false
                    }
                }
            }
        })
        print("3")
        yourEmail = yourEmail.replacingOccurrences(of: ".", with: "-")
        print("yourEmail: " + yourEmail)
        let nowUserRef3 = FirebaseDataService.instance.userRef.child(yourEmail).child("realloveday")
        nowUserRef3.observeSingleEvent(of: .value, with: {(snapshot) in
            print("3-1")
            let values = snapshot.value
            let dic = values as! Dictionary<String, String>
            
            for index in dic{
                if index.key == "sunday"{
                    if index.value == "true"{
                        yourLoveDay[0] = true
                    }
                    else{
                        yourLoveDay[0] = false
                    }
                }
                if index.key == "monday"{
                    if index.value == "true"{
                        yourLoveDay[1] = true
                    }
                    else{
                        yourLoveDay[1] = false
                    }
                }
                if index.key == "tuesday"{
                    if index.value == "true"{
                        yourLoveDay[2] = true
                    }
                    else{
                        yourLoveDay[2] = false
                    }
                }
                if index.key == "wednesday"{
                    if index.value == "true"{
                        yourLoveDay[3] = true
                    }
                    else{
                        yourLoveDay[3] = false
                    }
                }
                if index.key == "thursday"{
                    if index.value == "true"{
                        yourLoveDay[4] = true
                    }
                    else{
                        yourLoveDay[4] = false
                    }
                }
                if index.key == "friday"{
                    if index.value == "true"{
                        yourLoveDay[5] = true
                    }
                    else{
                        yourLoveDay[5] = false
                    }
                }
                if index.key == "saturday"{
                    if index.value == "true"{
                        yourLoveDay[6] = true
                    }
                    else{
                        yourLoveDay[6] = false
                    }
                }
            }
        })
        print("4")
        for i in 0..<7 {
            if(myLoveDay[i] == true && yourLoveDay[i] == true){
                realdays += 1
            }
        }
        print("Calcul/")
    }
    
    func setNow(){ //현재 날짜와 시간 셋팅
        print("/setNow")
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // --- 2
        let stringDate = formatter.string(from: date) // --- 3
        
        var start = stringDate.index(stringDate.startIndex, offsetBy: 0)
        var end = stringDate.index(stringDate.startIndex, offsetBy: 4)
        var range = start..<end
        
        nowYear = Int(stringDate.substring(with: range))!
        
        start = stringDate.index(stringDate.startIndex, offsetBy: 5)
        end = stringDate.index(stringDate.startIndex, offsetBy: 7)
        range = start..<end
        
        nowMonth = Int(stringDate.substring(with: range))!
        
        start = stringDate.index(stringDate.startIndex, offsetBy: 8)
        end = stringDate.index(stringDate.startIndex, offsetBy: 10)
        range = start..<end
        
        nowDay = Int(stringDate.substring(with: range))!
        
        start = stringDate.index(stringDate.startIndex, offsetBy: 11)
        end = stringDate.index(stringDate.startIndex, offsetBy: 13)
        range = start..<end
        
        nowHour = Int(stringDate.substring(with: range))!
        
        start = stringDate.index(stringDate.startIndex, offsetBy: 14)
        end = stringDate.index(stringDate.startIndex, offsetBy: 16)
        range = start..<end
        
        nowMin = Int(stringDate.substring(with: range))!
        
        start = stringDate.index(stringDate.startIndex, offsetBy: 17)
        end = stringDate.index(stringDate.startIndex, offsetBy: 19)
        range = start..<end
        
        nowSec = Int(stringDate.substring(with: range))!
        
        var comps = cal.dateComponents([.weekday], from: date)
        var weekday1: Int = 0
        if let weekday2 = comps.weekday{
            weekday1 = weekday2
            numWeekday = weekday1
        }
        switch weekday1{
        case 1:
            nowWeekday = WeekDay.Sun
        case 2:
            nowWeekday = WeekDay.Mon
        case 3:
            nowWeekday = WeekDay.Tue
        case 4:
            nowWeekday = WeekDay.Wed
        case 5:
            nowWeekday = WeekDay.Thu
        case 6:
            nowWeekday = WeekDay.Fri
        case 7:
            nowWeekday = WeekDay.Sat
        default:
            nowWeekday = WeekDay.Mon
        }
        print("setNow/")
    }
    
    func Change(){
        print("/Change")
        setNow()
        
        if(nowWeekday == WeekDay.Sun){ //일요일이면 계산
            Calcul()
            var thisdays = realdays
            var nowText = String(thisdays) + " Days!"
            RealDays.text = nowText
            UpperText.text = "Your real love days are"
            self.view.bringSubviewToFront(RealDays)
            if(realdays <= 3){
                BottomText.text = "Oh my god..."
            }
            else{
                BottomText.text = "Congraturations"
            }
        }
        else if(nowWeekday == WeekDay.Mon && nowHour == 0 && nowMin == 0 && nowSec == 0){
            realdays = 0
            self.view.sendSubviewToBack(RealDays)
        }
        else{
            RealDays.text = ""
            UpperText.text = "We're calculating"
            BottomText.text = "Please wait for it"
            
            rotate(imageView: WaitingImage, aCircleTime: 5)
        }
        
        if(selected[numWeekday-1] == false){
            LeadText.text = "Make up your mind ->"
        }
        else{
            LeadText.text = "You already did"
        }
        print("Change/")
    }
    
    override func viewDidLoad() {
        //Auth.text = "Welcome " + Email
        Change()
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Change()
        
        super.viewDidAppear(animated)
    }
}
