//
//  UuusDatesAndTimes_.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import Foundation

extension Date {
    // MARK: - Enumerations

    public enum DateFormat: String {
        case none
        case count

        /// hour
        /// minute
        /// second
        case hms
        case Hm = "H:m"
        case HHmm = "HH:mm"
        case ms = "m:s"
        case mmss = "mm:ss"
        case Hms = "H:m:s"
        case HHmmss = "HH:mm:ss"

        case whitespace

        /// year
        /// month
        /// day
        case ymd
        case M_d = "M-d"
        case MM_dd = "MM-dd"
        case yyyy_M = "yyyy-M"
        case yyyy_MM = "yyyy-MM"
        case yyyy_M_d = "yyyy-M-d"
        case yyyy_MM_dd = "yyyy-MM-dd"

        /// 年 月 日
        case nyr
        case dr = "d日"
        case ddr = "dd日"
        case Mydr = "M月d日"
        case MMyddr = "MM月dd日"
        case yyyynMy = "yyyy年M月"
        case yyyynMMy = "yyyy年MM月"
        case yyyynMydr = "yyyy年M月d日"
        case yyyynMMyddr = "yyyy年MM月dd日"
    }
}

extension Date {
    // MARK: - Properties

    public var timestamp: TimeInterval {
        return timeIntervalSince1970 * 1000
    }

    public var tomorrow: Date {
        return self + TimeInterval(60 * 60 * 24)
    }

    public var yesterday: Date {
        return self - TimeInterval(60 * 60 * 24)
    }

    public var weekOfYear: Int {
        return value(for: .weekOfYear)
    }

    public var weekday: String {
        let weekdays = [
            "周六".local, "周日".local,
            "周一".local, "周二".local,
            "周三".local, "周四".local,
            "周五".local, "周六".local,
        ]
        return weekdays[value(for: .weekday)]
    }

    public var mondate: Date {
        /// Sunday = 1, Monday = 2, Saturday = 7
        ccalendar.firstWeekday = 2
        var components: Set<Calendar.Component>
        components = [.day, .month, .weekday, .year]
        var dateComponents = ccalendar.dateComponents(components, from: self)
        var leading = -6
        if dateComponents.weekday != 1 {
            leading = ccalendar.firstWeekday - (dateComponents.weekday ?? 0)
        }
        dateComponents.day = dateComponents.day! + leading
        return ccalendar.date(from: dateComponents)!
    }
}

extension Date {
    // MARK: - Public - Functions

    /// let a = "1992-02-29"
    /// let b = [Date.DateFormat.yyyy_MM_dd]
    /// let c = Date.date(of: a, input: b)
    ///
    /// print(a, b, c)
    /// 1992-02-29 [Foundation.Date.DateFormat.yyyy_MM_dd] Optional(1992-02-28 16:00:00 +0000)
    public static func date(of string: String, input: [DateFormat]) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = input.dateFormat
        return formatter.date(from: string)
    }

    /// let a = "1992-02-29 20:00"
    /// let b = [Date.DateFormat.yyyy_MM_dd]
    /// let c = [Date.DateFormat.yyyy_MM_dd, .HHmm]
    /// let d = Date.date(of: a, input: c)!
    /// let e = Date.date(of: d, _inout: b)
    ///
    /// print(a, d, e)
    /// 1992-02-29 20:00 1992-02-29 12:00:00 +0000 Optional(1992-02-28 16:00:00 +0000)
    public static func date(of date: Date, _inout: [DateFormat]) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = _inout.dateFormat
        let string = formatter.string(from: date)
        return formatter.date(from: string)
    }

    /// let a = "1992-02-29"
    /// let b = [Date.DateFormat.yyyy_MM_dd]
    /// let c = Date.aged(of: a, input: b)
    ///
    /// print(a, b, c)
    /// 1992-02-29 [Foundation.Date.DateFormat.yyyy_MM_dd] 25.6666666666667
    public static func aged(of string: String, input: [DateFormat]) -> TimeInterval {
        let birthdate = date(of: string, input: input) ?? .distantPast
        let components: Set<Calendar.Component> = [.month, .year]
        let dateComponents = ccalendar.dateComponents(components, from: birthdate, to: Date())
        return TimeInterval(dateComponents.year ?? 0) + TimeInterval(dateComponents.month ?? 0) / 12
    }

    /// let a = "1992-02-29 20:29"
    /// let b = [Date.DateFormat.yyyy_MM_dd, .HHmm]
    /// let c = Date.date(of: a, input: b)!
    /// let d = Date.hour(of: c.timestamp)
    ///
    /// print(a, c, d)
    /// 1992-02-29 20:29 1992-02-29 12:29:00 +0000 20.4833333333333
    public static func hour(of timestamp: TimeInterval) -> TimeInterval {
        let hour = timestamp.date.value(for: .hour)
        let minute = timestamp.date.value(for: .minute)
        return TimeInterval(hour) + TimeInterval(minute) / 60
    }

    /// let a = "1992-02-29"
    /// let b = "1992-02-29 20:00"
    /// let c = "1992-03-09 20:00"
    ///
    /// let d: [Date.DateFormat] = [.yyyy_MM_dd]
    /// let e: [Date.DateFormat] = [.yyyy_MM_dd, .HHmm]
    /// let f: [Date.DateFormat] = [.yyyynMydr, .HHmmss]
    ///
    /// let h = Date.date(of: a, input: d)!.timestamp
    /// let i = Date.date(of: b, input: e)!.timestamp
    /// let j = Date.date(of: c, input: e)!.timestamp
    ///
    /// let k = Date.jointed(as: f, start: h)
    /// let l = Date.jointed(as: f, start: h, end: i)
    /// let m = Date.jointed(as: e, start: h, end: j)
    ///
    /// print(k, l, m)
    /// ("1992年2月29日 00:00:00", nil) ("1992年2月29日 00:00:00 - 20:00:00", Optional(1)) ("1992-02-29 00:00 - 03-09 20:00", Optional(10))
    public static func jointed(as output: [DateFormat], start: TimeInterval, end: TimeInterval? = nil) -> (String, Int?) {
        guard let end = end else { return (start.date.string(as: output), nil) }

        let white_space: String = .white + .short + .white
        let output = output.sorted { $0.hashValue > $1.hashValue }
        guard output.first!.hashValue > DateFormat.whitespace.hashValue else {
            return ("\(start.date.string(as: output))\(white_space)\(end.date.string(as: output))", 1)
        }

        let components: Set<Calendar.Component> = [.day, .month, .year]
        let endComponents = ccalendar.dateComponents(components, from: end.date)
        let startComponents = ccalendar.dateComponents(components, from: start.date)

        let day = startComponents.day == endComponents.day
        let year = startComponents.year == endComponents.year
        let month = startComponents.month == endComponents.month

        let endDate = date(of: end.date, _inout: [.yyyy_MM_dd]) ?? Date()
        let startDate = date(of: start.date, _inout: [.yyyy_MM_dd]) ?? Date()
        let dayInterval = Int((endDate.timestamp - startDate.timestamp).day) + 1

        var beauty = output

        switch (day, month, year) {
        case (false, false, true):
            switch output.first! {
            case .yyyy_M_d: beauty[0] = .M_d
            case .yyyy_MM_dd: beauty[0] = .MM_dd
            case .yyyynMydr: beauty[0] = .Mydr
            case .yyyynMMyddr: beauty[0] = .MMyddr
            default: break
            }
        case (false, true, true):
            switch output.first! {
            case .yyyy_M_d: beauty[0] = .M_d
            case .yyyy_MM_dd: beauty[0] = .MM_dd
            case .yyyynMydr: beauty[0] = .dr
            case .yyyynMMyddr: beauty[0] = .ddr
            default: break
            }
        case (true, true, true):
            switch output.count == 1 {
            case true:
                return ("\(start.date.string(as: output))", 1) // (1970+01+01, 1)
            case false:
                return ("\(start.date.string(as: output))\(white_space)\(end.date.string(as: [output.last!]))", 1)
            }
        default:
            return ("\(start.date.string(as: output))\(white_space)\(end.date.string(as: output))", dayInterval)
        }

        return ("\(start.date.string(as: output))\(white_space)\(end.date.string(as: beauty))", dayInterval)
    }

    public typealias OutputItem = ([DateFormat], start: TimeInterval, end: TimeInterval, format: String)
    public typealias ExtentItem = (start: Date, end: Date, againstf: Bool, suffix: String?, now: String?)

    /// see TimeInterval.history
    public static func string(as output: [OutputItem], timeInterval: [ExtentItem]) -> String {
        let currentDate = Date()

        for interval in timeInterval {
            if currentDate < interval.start || currentDate >= interval.end {
                continue // [interval.start, interval.end)
            }

            let components: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
            let from = interval.againstf ? interval.start : currentDate
            let to = interval.againstf ? currentDate : interval.end
            let fromComponents = ccalendar.dateComponents(components, from: from)
            let toComponents = ccalendar.dateComponents(components, from: to)
            let dateComponents = ccalendar.dateComponents(components, from: from, to: to)
            let againstDate = interval.againstf ? interval.start : interval.end

            func string(as output: OutputItem, count: TimeInterval) -> String {
                switch output.0.first! {
                case .count:
                    return String(format: output.format, count)
                case .none:
                    return String(format: output.format, String.empty)
                case .whitespace:
                    return String(format: output.format, String.white)
                default:
                    let againstValue = againstDate.string(as: output.0)
                    return String(format: output.format, againstValue)
                }
            }

            func string(as output: [OutputItem], day dateComponents: DateComponents, from: Date, to: Date) -> String? {
                let toDate = date(of: to, _inout: [.yyyy_MM_dd])!
                let fromDate = date(of: from, _inout: [.yyyy_MM_dd])!
                let currentDay = (toDate.timestamp - fromDate.timestamp).day
                for outputItem in output {
                    if currentDay < outputItem.start.day || currentDay > outputItem.end.day {
                        continue
                    }
                    if outputItem.0 == [.count] && dateComponents.day == 0 {
                        if let hourString = string(as: output, hour: dateComponents) {
                            return hourString
                        }
                    } else {
                        return string(as: outputItem, count: currentDay) + (interval.suffix ?? .empty)
                    }
                }
                return nil
            }

            func string(as output: [OutputItem], hour dateComponents: DateComponents) -> String? {
                let currentHour = TimeInterval(dateComponents.hour ?? 0)
                for outputItem in output {
                    if currentHour < outputItem.start.hour || currentHour > outputItem.end.hour {
                        continue
                    }
                    return string(as: outputItem, count: currentHour) + (interval.suffix ?? .empty)
                }
                return nil
            }

            func string(as output: [OutputItem], minute dateComponents: DateComponents) -> String? {
                let currentMinute = dateComponents.minute ?? 0
                for outputItem in output {
                    if currentMinute < outputItem.start.minute || currentMinute > outputItem.end.minute {
                        continue
                    }
                    return string(as: outputItem, count: TimeInterval(currentMinute)) + (interval.suffix ?? .empty)
                }
                return nil
            }

            func string(as output: [OutputItem], second dateComponents: DateComponents) -> String? {
                let currentSecond = dateComponents.second ?? 0
                for outputItem in output {
                    if currentSecond < outputItem.start.second || currentSecond > outputItem.end.second {
                        continue
                    }
                    return string(as: outputItem, count: TimeInterval(currentSecond)) + (interval.suffix ?? .empty)
                }
                return nil
            }

            let day = fromComponents.day == toComponents.day
            let year = fromComponents.year == toComponents.year
            let month = fromComponents.month == toComponents.month

            // TODO: several months ago, several years ago

            if !day || !month || !year {
                if let dayString = string(as: output, day: dateComponents, from: from, to: to) {
                    return dayString
                }
            } else if 1 <= dateComponents.hour ?? 0 {
                if let hourString = string(as: output, hour: dateComponents) {
                    return hourString
                }
            } else if 1 <= dateComponents.minute ?? 0 {
                if let minuteString = string(as: output, minute: dateComponents) {
                    return minuteString
                }
            } else if 1 <= dateComponents.second ?? 0 {
                if let secondString = string(as: output, second: dateComponents) {
                    return secondString
                }
            }

            return interval.now ?? .short
        }

        return .short
    }

    public static func daysLater(interval: (TimeInterval, TimeInterval)) -> String {
        let lminute = TimeInterval.lminute
        let onehour = TimeInterval.onehour
        let oneday = TimeInterval.oneday
        let future = Date.distantFuture
        let before = Date.distantPast

        let outputItem: [OutputItem] = [
            ([.count], 0, lminute - 1, "%.f秒钟".local),
            ([.count], lminute, onehour - 1, "%.f分钟".local),
            ([.count], onehour, oneday - 1, "%.f小时".local),
            ([.count], oneday, future.timestamp, "%.f天".local),
        ]

        let extentItem: [ExtentItem] = [
            (before, interval.0.date, false, "后开始".local, "开始".local),
            (interval.0.date, interval.1.date, false, "后结束".local, "结束".local),
            (interval.1.date, future, true, "前".local, "已结束".local),
        ]

        return string(as: outputItem, timeInterval: extentItem)
    }
}

extension Date {
    // MARK: - Public - Functions

    /// let a = "1992-02-29"
    /// let b = [Date.DateFormat.yyyy_MM_dd]
    /// let c = Date.date(of: a, input: b)
    ///
    /// let d = c!.value(for: .day)
    /// let e = c!.value(for: .weekday)
    /// let f = c!.value(for: .weekOfMonth)
    ///
    /// print(d, e, f)
    /// 29 7 5
    public func value(for component: Calendar.Component) -> Int {
        return ccalendar.component(component, from: self)
    }

    /// let a = "1992-02-29"
    /// let b = [Date.DateFormat.yyyynMydr]
    /// let c = [Date.DateFormat.yyyy_MM_dd]
    /// let d = Date.date(of: a, input: c)!
    /// let e = d.string(as: b)
    ///
    /// print(a, d, e)
    /// 1992-02-29 1992-02-28 16:00:00 +0000 1992年2月29日
    public func string(as output: [DateFormat]) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = output.dateFormat
        return formatter.string(from: self)
    }
}

extension TimeInterval {
    // MARK: - Singleton

    public static let oneweek: TimeInterval = 7 * oneday
    public static let oneday: TimeInterval = 24 * onehour
    public static let onehour: TimeInterval = 60 * lminute
    public static let lminute: TimeInterval = 60 * lsecond
    public static let lsecond: TimeInterval = TimeInterval(1000)
}

extension TimeInterval {
    // MARK: - Properties

    public var date: Date {
        /// millisecond -> second
        return Date(timeIntervalSince1970: self * 0.001)
    }

    public var day: TimeInterval {
        return self / 1000 / 60 / 60 / 24
    }

    public var hour: TimeInterval {
        return self / 1000 / 60 / 60
    }

    public var minute: Int {
        return Int(self) / 1000 / 60 % 60
    }

    public var second: Int {
        return Int(self) / 1000 % 60
    }

    public var hhmm: String {
        let hm = "\(Int(hour)):\(minute)"
        return Date.date(of: hm, input: [.Hm])!.string(as: [.HHmm])
    }

    public var hhmmss: String {
        let hms = "\(Int(hour)):\(minute):\(second)"
        return Date.date(of: hms, input: [.Hms])!.string(as: [.HHmmss])
    }

    public var oneweek: TimeInterval {
        return TimeInterval.oneweek
    }

    public var oneday: TimeInterval {
        return TimeInterval.oneday
    }

    public var onehour: TimeInterval {
        return TimeInterval.onehour
    }

    public var lminute: TimeInterval {
        return TimeInterval.lminute
    }

    public var lsecond: TimeInterval {
        return TimeInterval.lsecond
    }

    public var history: String? {
        if Date() < date { return nil }
        let output: [Date.OutputItem] = [
            ([.HHmm], 0, oneday - 1, .marka), // in same day
            ([.HHmm], oneday, 2 * oneday - 1, "昨天".local + .marka),
            ([.HHmm], 2 * oneday, oneweek - 1, date.weekday + .marka),
            ([.MMyddr, .HHmm], oneweek, Date.distantFuture.timestamp, .marka),
        ]
        let extent: [Date.ExtentItem] = [(date, .distantFuture, true, nil, "现在".local)]
        return Date.string(as: output, timeInterval: extent)
    }
}
