//
//  DataCenter.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 5. 9..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import Foundation
import Firebase


// ALBUM
struct Album {
    let year : Int
    let month : Int
    let day : Int
    var photo : [String]
}

var A20190531 = Album(year: 2019, month: 5, day: 31, photo: ["image1.jpeg", "image2.jpeg"])
var albums : [Album] = []

// DAY
var myLoveDay : [Bool] = [false, false, false, false, false, false, false]
var yourLoveDay : [Bool] = [false, false, false, false, false, false, false]

var selected : [Bool] = [false, false, false, false, false, false, false]

var date = Date()
var formatter = DateFormatter()
var cal = Calendar(identifier: .gregorian)

enum WeekDay {
    case Mon, Tue, Wed, Thu, Fri, Sat, Sun
}

var nowYear = 0, nowMonth = 0, nowDay = 0, nowHour = 0, nowMin = 0, nowSec = 0
var nowWeekday : WeekDay = WeekDay.Mon
var numWeekday : Int = 0
var realdays : Int = 0

// LOGIN
var Email: String = ""
var Password: String = ""
var myBirthDate: String = ""
var ourLoveDate: String = ""
var myUid : String = ""

//CHAT
// 말풍선 하나
struct ChatMessage {
    var fromUserId: String
    var text: String
    var timestamp: NSNumber
}

// 채팅방
struct Group {
    var key: String
    var name: String
    var messages: Dictionary<String, Int>
    
    init(key: String, name: String) {
        self.key = key
        self.name = name
        self.messages = [:]
    }
    
    init(key: String, data: Dictionary<String, AnyObject>) {
        self.key = key
        self.name = data["name"] as! String
        if let messages = data["messages"] as? Dictionary<String, Int> {
            self.messages = messages
        } else {
            self.messages = [:]
        }
    }
}

// 사용자
struct User {
    var uid: String
    var email: String
    var username: String
    var group: Dictionary<String, String>
    
    init(uid: String, email: String, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
        self.group = [:]
    }
}
