//
//  AGDate.swift
//  AGWheel
//
//  Created by Anthony on 2022/4/12.
//

import Foundation


extension Date {
    
    public struct AGDateComponent{
        var year: Int?
        var month: Int?
        var day: Int?
        
        var describe: String? {
            get {
                return "\(year)\(month)\(day)"
            }
        }
    }
    

    
    /// 获得 指定日期的 年月日结构体
    var now: AGDateComponent {
        get {
            var  coms = AGDateComponent()
//            let date =  Date()
            let calendar = Calendar.current
            
            coms.month = calendar.component(.month, from: self)
            coms.year = calendar.component(.year, from: self)
            coms.day = calendar.component(.day, from: self)

            return coms
        }
    }
    
    
    /// 根据年月得到这个月有多少天
    /// - Parameters:
    ///   - year: 年
    ///   - month: 月
    /// - Returns: 天数
    public func ag_getDayInMonth(year: Int, month: Int)  -> Int {
        var startComps = DateComponents()
        
        startComps.year = year
        startComps.month = month
        startComps.day = 1
        
        var endComps = DateComponents()
        
        endComps.year = year
        endComps.month = month + 1
        
        if month == 12{
            endComps.year = year + 1
            endComps.month = 1
        }
        endComps.day  = 1
        
        let calendar = Calendar.current
        
        let dayRange = calendar.dateComponents([.day], from: startComps,to: endComps)
        
        return dayRange.day ?? 0
    
    }
    
    
    
    /// 只有年月日的字符串
    func ag_dataWithYMD() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: self)
        let result = fmt.date(from: selfStr)!
        print(result)
        return selfStr
    }
    
    ///获取当前年月日的时间戳
    func ag_timeIntervalWithYMDDate() -> TimeInterval {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        let selfStr = fmt.string(from: self)
        let result = fmt.date(from: selfStr)!
        return result.timeIntervalSinceReferenceDate + 24 * 60 * 60
    }
    
    /// 获得与当前时间的差距
    /// - Returns: houe minute second
    func ag_deltaWithNow() -> DateComponents {
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.hour,.minute,.second], from: self, to: Date())
        return cmps
    }
    /// 获取当前 秒级 时间戳 - 10位
    var ag_secondStamp : String {
        return String.init(format: "%.0f", self.timeIntervalSince1970)
    }
    
    /// 获取当前 毫秒级  时间戳 - 13位
    var ag_millStamp: String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millSecond = CLongLong(round(timeInterval*1000))
        return String(millSecond)
    }
    
    /// 当前是本月第几天
    /// - Returns: 第几天
    func ag_day() -> Int? {
        let components: DateComponents? = Calendar.current.dateComponents([.day], from: self)
        return components?.day
    }
    
    /// 当前是今天第几个小时
    /// - Returns:  第几小时
    func ag_getHour() -> Int {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour], from: self)
        return dateComponents.hour ?? 0
    }
    
    
    
    /// 日期是不是今天
    /// - Returns: bool
    func ag_isToday()  -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfComps = calendar.dateComponents(unit, from: self)
        
        return (selfComps.year == nowComps.year) &&
        (selfComps.month == nowComps.month) &&
        (selfComps.day == nowComps.day)
    }
    
    /// 日期是不是昨天
    /// - Returns: bool
    func ag_isYesterday() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfComps = calendar.dateComponents(unit, from: self)
        if selfComps.day == nil || nowComps.day == nil {
            return false
        }
        let count = nowComps.day! - selfComps.day!
        return (selfComps.year == nowComps.year) &&
            (selfComps.month == nowComps.month) &&
            (count == 1)
    }
    
    
    
    /// 是否为今年
    /// - Returns: bool
    func ag_isThisYear() -> Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date())
        let selfCmps = calendar.dateComponents([.year], from: self)
        let result = nowCmps.year == selfCmps.year
        return result
    }
}


extension Date {
    
    
    // MARK: ----- 从 date 获取年月日等等 -----
    var ag_Year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var ag_Month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var ag_Day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var ag_Hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var ag_Minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    
    var ag_Second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    var ag_Nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }
    
    var ag_Weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    

    
    var ag_WeekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }
    
    var ag_WeekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    var ag_YearForWeekOfYear: Int {
        return Calendar.current.component(.yearForWeekOfYear, from: self)
    }
        
//case era

//case weekdayOrdinal
//
//case quarter
//
////
//case calendar
//
//case timeZone
    
}
