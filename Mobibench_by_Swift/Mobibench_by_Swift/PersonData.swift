//
//  PersonData.swift
//  Mobibench_by_Swift
//
//  Created by Yoonsik on 10/2/16.
//  Copyright © 2016 Yoonsik. All rights reserved.
//

import UIKit

class PersonData: NSObject {
    var name: NSString
    var telno: NSString
    var email: NSString
    
    init(name: NSString, phoneNumber: NSString, mailAddr: NSString) {
        // 전달받은 값을 저장
        self.name = name
        self.telno = phoneNumber
        self.email = mailAddr
    }
}
