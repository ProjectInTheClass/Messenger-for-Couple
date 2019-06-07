//
//  DataCenter.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 5. 9..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import Foundation

struct Album {
    let year : Int
    let month : Int
    let day : Int
    var photo : [Any]
}

var A20190531 = Album(year: 2019, month: 5, day: 31, photo: ["image1.jpeg", "image2.jpeg"])
var albums : [Album] = [A20190531]


