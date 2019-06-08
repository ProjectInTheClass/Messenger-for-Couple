//
//  DaysViewController.swift
//  Latte1
//
//  Created by 이현지 on 03/06/2019.
//  Copyright © 2019 남혜빈. All rights reserved.
//

import UIKit
import Foundation

class DaysViewController: UIViewController {
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
        myLoveDay[numWeekday-1] = true
        selected[numWeekday-1] = true
        
        Change()
    }
    
    func SelectNo(){
        myLoveDay[numWeekday-1] = false
        selected[numWeekday-1] = true
        
        Change()
    }
    
    func rotate(imageView: UIImageView, aCircleTime: Double) { //CABasicAnimation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2 //Minus can be Direction
        rotationAnimation.duration = aCircleTime
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: nil)
    }
        
    func Calcul(){
        for i in 1..<8 {
            if(myLoveDay[i] == true && yourLoveDay[i] == true){
                realdays += 1
            }
        }
    }
    
    func setNow(){ //현재 날짜와 시간 셋팅
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
    }
    
    func Change(){
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
        if(nowWeekday == WeekDay.Mon && nowHour == 0 && nowMin == 0 && nowSec == 0){
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
    }
    
    override func viewDidLoad() {
        Change()
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Change()
        
        super.viewDidAppear(animated)
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
