//
//  profile.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import Foundation

class profile {
    
    var name : String
    var age : Int
    var gender : genderType
    
    var description : String?
    var profilePicUrl : String?
    
    init() {
        name = "aaa"
        age = 12
        gender = .male
    }
}

enum genderType{
    case male
    case female
}
