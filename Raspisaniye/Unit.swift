//
//  Unit.swift
//  Raspisaniye
//
//  Created by _ on 11/3/16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import Foundation
import RealmSwift

class Unit: Object {

    dynamic var name:String = ""
    dynamic var ID:Int = 0
    //FIXIT - change from int to enum
    dynamic var type:Int = 0 // 0 - group 1 - lector

    override static func primaryKey() -> String? {
        return "name"
    }

}
