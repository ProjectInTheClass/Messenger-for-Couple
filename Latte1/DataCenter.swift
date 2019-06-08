//
//  DataCenter.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 5. 9..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import Foundation

// ALBUM
struct Album {
    let year : Int
    let month : Int
    let day : Int
    var photo : [Any]
}

var A20190531 = Album(year: 2019, month: 5, day: 31, photo: ["image1.jpeg", "image2.jpeg"])
var albums : [Album] = [A20190531]

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
