//
//  Model_Realm.swift
//  Ethno
//
//  Created by whitehorse on 2019/11/14.
//  Copyright © 2019 Ethno. All rights reserved.
//

import Foundation
import RealmSwift

class Alarm : Object {
    @objc dynamic var alarm_hour = ""
    @objc dynamic var alarm_min = ""
    @objc dynamic var alarm_status = false
}
