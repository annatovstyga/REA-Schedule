//
//  Day.swift
//  Raspisaniye
//
//  Created by Анна Товстыга on 23.09.16.
//  Copyright © 2016 rGradeStd. All rights reserved.
//

import Foundation
import RealmSwift

class Day: Object {
    var lessons = List<Lesson>()
    dynamic var dayName:  String?
    
    dynamic var date:  String?
    
   
//    override static func primaryKey() -> String? {
//        return "date"
//    }
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }

}
