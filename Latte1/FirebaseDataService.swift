//
//  FirebaseDataService.swift
//  Latte1
//
//  Created by 남혜빈 on 2019. 6. 12..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import Foundation
import Firebase

fileprivate let baseRef = Database.database().reference()


class FirebaseDataService {
    static let instance = FirebaseDataService()
    
    // Get a reference to the storage service using the default Firebase App
    let storage = Storage.storage()
    
    // 특정 데이터들이 저장되는 장소에 대한 레퍼런스
    // user : 특정 사용자
    let userRef = baseRef.child("user")
    
    // group : 채팅방 하나 단위
    let groupRef = baseRef.child("group")
    
    // message : 채팅 말풍선 하나 단위
    let messageRef = baseRef.child("message")
    
    // 현재 접속중인 유저의 uid
    
    
    var currentUserEmail: String? {
        
        get {
            guard let uid = Auth.auth().currentUser?.email else {
                return nil
            }
            return uid
        }
    }
}
