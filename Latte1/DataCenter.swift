//
//  DataCenter.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 5. 9..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import Foundation

struct Album {
    let name : String
    var photo : [Any]
}

var favorite = Album(name:"favorite", photo: ["image1.jpeg", "image2.jpeg"])
var albums : [Album] = [favorite]


