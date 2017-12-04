//
//  UuusEventKit.swift
//  Example
//
//  Created by 范炜佳 on 19/10/2017.
//  Copyright © 2017 com.uuus. All rights reserved.
//

import EventKit
import PKHUD

extension EKEventStore {
    // MARK: - Public - Functions

    public static func newEvent(with title: String, location: String? = nil, isAllDay: Bool = false, startDate: Date, endDate: Date, alarms: [TimeInterval]? = nil, calendar: String? = nil, completion: completionc? = nil) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion?(error)
                    return
                }

                guard granted else {
                    let local = "新建提醒失败, 请到隐私设置日历权限".local
                    HUD.flash(.label(local), delay: 0.5)
                    completion?(nil)
                    return
                }

                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.location = location
                event.isAllDay = isAllDay
                event.startDate = startDate
                event.endDate = endDate
                alarms?.forEach({ interval in
                    event.addAlarm(EKAlarm(relativeOffset: interval))
                })
                event.calendar = eventStore.newEKCalendar(calendar)

                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch _ {
                    return
                }
                completion?(event)
            }
        }
    }

    public func newEKCalendar(_ calendar: String?) -> EKCalendar {
        guard calendar != nil else {
            return defaultCalendarForNewEvents!
        }

        for ekCalendar in calendars(for: .event) {
            if ekCalendar.title == calendar {
                return ekCalendar
            }
        }

        var cloudSource: EKSource?
        var localSource: EKSource?
        sources.forEach { source in
            switch source.sourceType {
            case .local:
                localSource = source
            case .calDAV:
                if source.title == "iCloud" {
                    cloudSource = source
                }
            default:
                break
            }
        }

        let ekCalendar = EKCalendar(for: .event, eventStore: self)
        ekCalendar.source = cloudSource ?? localSource!
        ekCalendar.title = calendar ?? String.short
        ekCalendar.cgColor = UIColor.purple.cgColor
        do {
            try saveCalendar(ekCalendar, commit: true)
        } catch _ {
            return defaultCalendarForNewEvents!
        }

        return ekCalendar
    }
}
