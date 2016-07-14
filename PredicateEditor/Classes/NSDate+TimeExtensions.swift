//
//  NSDate+TimeExtensions.swift
//  Pods
//
//  Created by Arvindh Sukumar on 14/07/16.
//
//

import Foundation
import Timepiece

extension NSDate {
    var time: NSDate {
        return change(year: 0, month: 0, day: 0, hour: hour, minute: minute, second: second)
    }
}