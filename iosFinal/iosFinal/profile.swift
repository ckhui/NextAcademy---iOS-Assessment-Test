//
//  profile.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import Foundation

class User {
    
    var uid : String
    var name : String
    var age : Int
    var gender : genderType
    var description : String?
    var profilePicUrl : String?
    
    init() {
        name = "name"
        age = 12
        gender = .male
        uid = "123"
    }
    
    init(withUid userId: String, userName : String,  userAge : String,  userGender : String, userDescription : String?, userPicUrl : String?) {
        uid = userId
        name = userName
        age = Int(userAge) ?? 0
        gender = .none
        if userGender == "m" {
            gender = .male
        }else if userGender == "f" {
            gender = .female
        }
        description = userDescription
        
        profilePicUrl = userPicUrl
        
    }
}

enum genderType{
    case male
    case female
    case none
}
