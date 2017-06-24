//
//  Extension.swift
//  barcampevn
//

import Foundation

extension String {
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date!)
    }
    
    var hour: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: date!)
    }
    
    var shortHour: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "HH:mm"
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    var hourDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: self)
        if let date = date {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(identifier: "UTC")!
            let unitFlags = Set<Calendar.Component>([.hour, .minute])
            let components = calendar.dateComponents(unitFlags, from: date)
            let newDate = calendar.date(from: components)
            return newDate
        }
        return nil
    }
    
    var longHourDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let date = dateFormatter.date(from: self)
        if let date = date {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(identifier: "UTC")!
            let unitFlags = Set<Calendar.Component>([.hour, .minute])
            let components = calendar.dateComponents(unitFlags, from: date)
            let newDate = calendar.date(from: components)
            return newDate
        }
        return nil
    }
    
    var tenMinuteBefor: TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: self) {
            let seconds = date.timeIntervalSince(Date())
            let interval = seconds - 600
            return interval
        }

        return 0
    }
    
    func testDate(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)!
        
        return date
    }
}

extension Date {
    
    var day: String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        return "\(day)"
    }
}
