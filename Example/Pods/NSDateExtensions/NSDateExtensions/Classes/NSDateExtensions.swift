//
//  NSDateExtensions.swift
//  Pods
//
//  Created by Matt Johnson <matt@intuitivedesignlabs.com> on 6/23/16.
//

import Foundation

public extension NSDate {
    private var componentFlags: NSCalendarUnit {
        get {
            return [.Year, .Month, .Day, .WeekOfMonth, .WeekOfYear, .Hour, .Minute, .Second, .Weekday, .WeekdayOrdinal]
        }
    }
    
    class var currentCalendar: NSCalendar {
        get {
            return NSCalendar.autoupdatingCurrentCalendar()
        }
    }
    
    struct Constants {
        static let minute = 60
        static let hour = minute * 60
        static let day = hour * 24
        static let week = day * 7
//        static let year = day * 365...
//            ...31556926 = 365.2422 days
    }
    
    //MARK: - Relative Dates
    class func daysFromNow(days: Int) -> NSDate {
        return NSDate().addDays(days)
    }
    
    class func daysBeforeNow(days: Int) -> NSDate {
        return NSDate().subtractDays(days)
    }
    
    class func tomorrow() -> NSDate {
        return NSDate.daysFromNow(1)
    }
    
    class func yesterday() -> NSDate {
        return NSDate.daysBeforeNow(1)
    }
    
    class func hoursFromNow(hours: Int) -> NSDate {
        let timeInterval = NSDate().timeIntervalSinceReferenceDate + Double(Constants.hour * hours)
        return NSDate(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    class func hoursBeforeNow(hours: Int) -> NSDate {
        let timeInterval = NSDate().timeIntervalSinceReferenceDate - Double(Constants.hour * hours)
        return NSDate(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    class func minutesFromNow(minutes: Int) -> NSDate {
        let timeInterval = NSDate().timeIntervalSinceReferenceDate + Double(Constants.minute * minutes)
        return NSDate(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    class func minutesBeforeNow(minutes: Int) -> NSDate {
        let timeInterval = NSDate().timeIntervalSinceReferenceDate - Double(Constants.minute * minutes)
        return NSDate(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    //MARK: - String Properties
    func stringWithFormat(format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    
    func stringWithDateStyle(dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.stringFromDate(self)
    }
    
    func shortString() -> String {
        return self.stringWithDateStyle(.ShortStyle, timeStyle: .ShortStyle)
    }
    
    func shortTimeString() -> String {
        return self.stringWithDateStyle(.NoStyle, timeStyle: .ShortStyle)
    }
    
    func shortDateString() -> String {
        return self.stringWithDateStyle(.ShortStyle, timeStyle: .NoStyle)
    }
    
    func mediumString() -> String {
        return self.stringWithDateStyle(.MediumStyle, timeStyle: .MediumStyle)
    }
    
    func mediumTimeString() -> String {
        return self.stringWithDateStyle(.NoStyle, timeStyle: .MediumStyle)
    }
    
    func mediumDateString() -> String {
        return self.stringWithDateStyle(.MediumStyle, timeStyle: .NoStyle)
    }
    
    func longString() -> String {
        return self.stringWithDateStyle(.LongStyle, timeStyle: .LongStyle)
    }
    
    func longTimeString() -> String {
        return self.stringWithDateStyle(.NoStyle, timeStyle: .LongStyle)
    }
    
    func longDateString() -> String {
        return self.stringWithDateStyle(.LongStyle, timeStyle: .NoStyle)
    }
    
    //MARK: - Comparing Dates
    func equalToDateIgnoringTime(date: NSDate) -> Bool {
        let components1 = NSDate.currentCalendar.components(componentFlags, fromDate:self)
        let components2 = NSDate.currentCalendar.components(componentFlags, fromDate:date)
        return ((components1.day == components2.day) && (components1.month == components2.month) && (components1.year == components2.year))
    }
    
    func today() -> Bool {
        return self.equalToDateIgnoringTime(NSDate())
    }
    
    func tomorrow() -> Bool {
        return self.equalToDateIgnoringTime(NSDate.tomorrow())
    }
    
    func yesterday() -> Bool {
        return self.equalToDateIgnoringTime(NSDate.yesterday())
    }

    func sameWeekAsDate(date:NSDate) -> Bool {
        let components1 = NSDate.currentCalendar.components(componentFlags, fromDate:self)
        let components2 = NSDate.currentCalendar.components(componentFlags, fromDate:date)
        if components1.weekOfYear != components2.weekOfYear { return false }
        return (fabs(self.timeIntervalSinceDate(date)) < Double(Constants.week))
    }
    
    func thisWeek() -> Bool {
        return self.sameWeekAsDate(NSDate())
    }
    
    func nextWeek() -> Bool {
        let timeInterval = NSDate().timeIntervalSinceReferenceDate + Double(Constants.week)
        let date = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        return self.sameWeekAsDate(date)
    }
    
    func lastWeek() -> Bool {
        let timeInterval = NSDate().timeIntervalSinceReferenceDate - Double(Constants.week)
        let date = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        return self.sameWeekAsDate(date)
    }
    
    func sameMonthAsDate(date: NSDate) -> Bool {
        let components1 = NSDate.currentCalendar.components([.Year, .Month], fromDate:self)
        let components2 = NSDate.currentCalendar.components([.Year, .Month], fromDate:date)
        return ((components1.month == components2.month) && (components1.year == components2.year));
    }
    
    func thisMonth() -> Bool {
        return self.sameMonthAsDate(NSDate())
    }
    
    func lastMonth() -> Bool {
        return self.sameMonthAsDate(NSDate().subtractMonths(1))
    }
    
    func nextMonth() -> Bool {
        return self.sameMonthAsDate(NSDate().addMonths(1))
    }
    
    func sameYearAsDate(date: NSDate) -> Bool {
        let components1 = NSDate.currentCalendar.components(.Year, fromDate:self)
        let components2 = NSDate.currentCalendar.components(.Year, fromDate:date)
        return (components1.year == components2.year);
    }
    
    func thisYear() -> Bool {
        return self.sameYearAsDate(NSDate())
    }
    
    func nextYear() -> Bool {
        let components1 = NSDate.currentCalendar.components(.Year, fromDate: self)
        let components2 = NSDate.currentCalendar.components(.Year, fromDate: NSDate())
        return (components1.year == (components2.year + 1))
    }
    
    func lastYear() -> Bool {
        let components1 = NSDate.currentCalendar.components(.Year, fromDate: self)
        let components2 = NSDate.currentCalendar.components(.Year, fromDate: NSDate())
        return (components1.year == (components2.year - 1))
    }
    
    func earlierThanDate(date: NSDate) -> Bool {
        return (self.compare(date) == .OrderedAscending)
    }
    
    func laterThanDate(date: NSDate) -> Bool {
        return (self.compare(date) == .OrderedDescending)
    }
    
    func inTheFuture() -> Bool {
        return self.laterThanDate(NSDate())
    }
    
    func inThePast() -> Bool {
        return self.earlierThanDate(NSDate())
    }
    
    //MARK: - Roles
    func typicallyWeekend() -> Bool {
        let components = NSDate.currentCalendar.components(.Weekday, fromDate: self)
        return ((components.weekday == 1) || (components.weekday == 7))
    }
    
    func typicallyWeekday() -> Bool {
        return !typicallyWeekend()
    }
    
    //MARK: - Adjusting Dates
    func addYears(years: Int) -> NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.year = years
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self, options: .WrapComponents)!
    }
    
    func subtractYears(years: Int) -> NSDate {
        return addYears(-years)
    }
    
    func addMonths(months: Int) -> NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.month = months
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self, options: .WrapComponents)!
    }
    
    func subtractMonths(months: Int) -> NSDate {
        return addMonths(-months)
    }
    
    func addDays(days: Int) -> NSDate {
        let dateComponents = NSDateComponents()
        dateComponents.day = days
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: self, options: .WrapComponents)!
    }
    
    func subtractDays(days: Int) -> NSDate {
        return addDays(-days)
    }
    
    func addHours(hours: Int) -> NSDate {
        let timeInterval = self.timeIntervalSinceReferenceDate + Double(Constants.hour * hours)
        return NSDate(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    func subtractHours(hours: Int) -> NSDate {
        return addHours(-hours)
    }
    
    func addMinutes(minutes: Int) -> NSDate {
        let timeInterval = self.timeIntervalSinceReferenceDate + Double(Constants.minute * minutes)
        return NSDate(timeIntervalSinceReferenceDate: timeInterval)
    }
    
    func subtractMinutes(minutes: Int) -> NSDate {
        return addMinutes(-minutes)
    }
    
    func componentsWithOffsetFromDate(date: NSDate) -> NSDateComponents {
        return NSDate.currentCalendar.components(componentFlags, fromDate: date, toDate: self, options: .WrapComponents)
    }
    
    //MARK: - Extremes
    func startOfDay() -> NSDate {
        let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        return NSDate.currentCalendar.dateFromComponents(components)!
    }
    
    func endOfDay() -> NSDate {
        let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        return NSDate.currentCalendar.dateFromComponents(components)!
    }
    
    //MARK: - Intervals
    func minutesAfterDate(date: NSDate) -> Int {
        let timeInterval = self.timeIntervalSinceDate(date)
        return Int(timeInterval / Double(Constants.minute))
    }
    
    func minutesBeforeDate(date: NSDate) -> Int {
        let timeInterval = date.timeIntervalSinceDate(self)
        return Int(timeInterval / Double(Constants.minute))
    }
    
    func hoursAfterDate(date: NSDate) -> Int {
        let timeInterval = self.timeIntervalSinceDate(date)
        return Int(timeInterval / Double(Constants.hour))
    }
    
    func hoursBeforeDate(date: NSDate) -> Int {
        let timeInterval = date.timeIntervalSinceDate(self)
        return Int(timeInterval / Double(Constants.hour))
    }
    
    func daysAfterDate(date: NSDate) -> Int {
        let timeInterval = self.timeIntervalSinceDate(date)
        return Int(timeInterval / Double(Constants.day))
    }
    
    func daysBeforeDay(date: NSDate) -> Int {
        let timeInterval = date.timeIntervalSinceDate(self)
        return Int(timeInterval / Double(Constants.day))
    }
    
//    func distanceInDaysToDate(date: NSDate) -> Int {
//        let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
//        let components = gregorianCalendar?.components(.Day, fromDate: self, toDate: date, options: .WrapComponents)
//        return components.day
//    }
    
    //MARK: - Decomposing Dates
    var nearestHour: Int {
        get {
            let timeInterval:NSTimeInterval = NSDate().timeIntervalSinceReferenceDate + Double(Constants.minute * 30)
            let date = NSDate(timeIntervalSinceReferenceDate: timeInterval)
            let components = NSDate.currentCalendar.components(componentFlags, fromDate: date)
            return components.hour
        }
    }
    
    var hour: Int {
        get {
            let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
            return components.hour
        }
    }
    
    var minute: Int {
        get {
            let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
            return components.minute
        }
    }
    
    var seconds: Int {
        get {
            let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
            return components.second
        }
    }
    
    var day: Int {
        get {
            let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
            return components.day
        }
    }
    
    var month: Int {
        get {
            let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
            return components.month
        }
    }
    
    var weekOfMonth: Int {
        get {
            let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
            return components.weekOfMonth
        }
    }
    
    var weekOfYear: Int {
        get {
            let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
            return components.weekOfYear
        }
    }
    
    var weekday: Int {
        get {
            let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
            return components.weekday
        }
    }
    
    var nthWeekday: Int {
        get {
            let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
            return components.weekdayOrdinal
        }
    }
    
    var year: Int {
        let components = NSDate.currentCalendar.components(componentFlags, fromDate: self)
        return components.year
    }
}
