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
import FirebaseDatabase

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
        
        if(((nowHour >= 0 && nowHour < 3) || (nowHour >= 21 && nowHour < 24)) && selected[numWeekday] == false){
            let chooseAlert = UIAlertController(title: "Make your mind", message: "do you love her/him?", preferredStyle: .alert)
            let LoveAction = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) -> Void in self.SelectYes()})
            let NoAction = UIAlertAction(title: "No", style: .default, handler: {(action: UIAlertAction) -> Void in self.SelectNo()})
            
            chooseAlert.addAction(LoveAction)
            chooseAlert.addAction(NoAction)
            
            self.present(chooseAlert, animated: true, completion: nil)
        }
        else if(selected[numWeekday] == true){
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
        selected[numWeekday] = true
        
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
        selected[numWeekday] = true
        
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
        print("4")
        for i in 0..<7 {
            if(myLoveDay[i] == true && yourLoveDay[i] == true){
                realdays += 1
            }
        }
        
        //캘린더에서 일주일동안 며칠 만났는지
        formatter.dateFormat = "yyyy-MM-dd"
        /*
         let lastSunday = formatter.string(from: Date(timeIntervalSinceNow: -86400*7))
         let thisMonday = formatter.string(from: Date(timeIntervalSinceNow: -86400*6))
         let thisTuesday = formatter.string(from: Date(timeIntervalSinceNow: -86400*5))
         let thisWednesday = formatter.string(from: Date(timeIntervalSinceNow: -86400*4))
         let thisThursday = formatter.string(from: Date(timeIntervalSinceNow: -86400*3))
         let thisFriday = formatter.string(from: Date(timeIntervalSinceNow: -86400*2))
         let thisSaturday = formatter.string(from: Date(timeIntervalSinceNow: -86400))
         */
        print("hello")
        for i in 1..<8{
            let thisDay = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(-86400*i)))
            print("thisday= " + thisDay)
            let nowSchedRef = FirebaseDataService.instance.schedRef.child(thisDay).child(MyEmail)
            nowSchedRef.observeSingleEvent(of: .value, with: {(snapshot) in
                let values = snapshot.value
                if let dic = values as? Dictionary<String, String>{
                    realdays += 1
                }
                else{
                }
            })
        }
        
        /*
         //일요일 : 지난주 일~이번주 토
         var lastSundayDay: Int = 0
         var lastSundayMonth: Int = 0
         var lastSundayYear: Int = 0
         
         lastSundayDay = nowDay-7
         if(lastSundayDay <= 0){
         lastSundayMonth = nowMonth - 1
         if(lastSundayMonth == 0) {
         lastSundayYear = nowYear - 1
         lastSundayMonth = 12
         }
         
         lastSundayDay = abs(lastSundayDay)
         switch lastSundayMonth{
         case 1,3,5,7,8,10,12:
         lastSundayDay = 31-lastSundayDay
         break
         case 4,6,9,11:
         lastSundayDay = 30-lastSundayDay
         break
         case 2:
         if lastSundayYear%4 == 0 && lastSundayYear%100 != 0 && lastSundayYear%400 == 0{
         lastSundayDay = 29-lastSundayDay
         }
         else{
         lastSundayDay = 28-lastSundayDay
         }
         break
         default:
         break
         }
         }
         print("last Sunday: " + String(lastSundayYear) + "-" + String(lastSundayMonth) + "-" + String(lastSundayDay))
         
         var thisSaturdayDay : Int = 0
         var thisSaturdayMonth : Int = 0
         var thisSaturdayYear : Int = 0
         
         thisSaturdayDay = nowDay-1
         if(thisSaturdayDay <= 0){
         thisSaturdayMonth = nowMonth - 1
         if(thisSaturdayMonth == 0) {
         thisSaturdayYear = nowYear - 1
         thisSaturdayMonth = 12
         }
         thisSaturdayDay = abs(thisSaturdayDay)
         switch thisSaturdayMonth{
         case 1,3,5,7,8,10,12:
         thisSaturdayDay = 31-thisSaturdayDay
         break
         case 4,6,9,11:
         thisSaturdayDay = 30-thisSaturdayDay
         break
         case 2:
         if nowYear%4 == 0 && nowYear%100 != 0 && nowYear%400 == 0{
         thisSaturdayDay = 29-thisSaturdayDay
         }
         else{
         thisSaturdayDay = 28-thisSaturdayDay
         }
         break
         default:
         break
         }
         }
         print("this Saturday: " + String(thisSaturdayYear) + "-" + String(thisSaturdayMonth) + "-" + String(thisSaturdayDay))
         
         let lastSunday = String(lastSundayYear) + "-" + String(lastSundayMonth) + "-" + String(lastSundayDay)
         let thisSaturday = String(thisSaturdayYear) + "-" + String(thisSaturdayMonth) + "-" + String(thisSaturdayDay)
         
         let nowSchedRef = FirebaseDataService.instance.schedRef.child(lastSunday).child(FirebaseDataService.instance.currentUserEmail!)
         nowSchedRef.observeSingleEvent(of: .value, with: {(snapshot) in
         let values = snapshot.value
         if let dic = values as? Dictionary<String, String>{
         realdays += 1
         }
         else{
         }
         })
         */
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
        //nowWeekday = WeekDay.Sun
        setNow()
        
        if(nowWeekday == WeekDay.Sun){ //일요일이면 계산
            Calcul()
            var thisdays = realdays
            var nowText = String(thisdays) + " Days!"
            RealDays.text = nowText
            print("nowText = " + nowText)
            UpperText.text = "Your real love days are"
            
            self.view.bringSubviewToFront(self.RealDays)
            self.WaitingImage.isHidden = true
            
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
            self.WaitingImage.isHidden = false
        }
        else{
            RealDays.text = ""
            UpperText.text = "We're calculating"
            BottomText.text = "Please wait for it"
            self.WaitingImage.isHidden = false
            
            rotate(imageView: WaitingImage, aCircleTime: 5)
        }
        
        if(selected[numWeekday] == false){
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
