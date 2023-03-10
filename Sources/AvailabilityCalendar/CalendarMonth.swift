//
//  CalendarMonth.swift
//  Calendar
//
//  Created by Roman R. on 5/30/22.
//  Copyright © 2022 r@resrom.com All rights reserved.
//

import SwiftUI

struct CalendarMonth: View {
    // MARK: - Properties -
    @ObservedObject var manager: CalendarManager
    let monthOffset: Int
    let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])
    let daysPerWeek = 7
    var monthsArray: [[Date]] {
        monthArray()
    }
    let cellHeight = CGFloat(30)
    
    // MARK: - View -
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 15) {
            Text(getMonthHeader())
                .foregroundColor(self.manager.colors.monthHeaderColor)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(monthsArray, id:  \.self) { row in
                    HStack() {
                        ForEach(row, id:  \.self) { column in
                            HStack() {
                                Spacer()
                                if self.isThisMonth(date: column) {
                                    let date = CalendarDate(date: column,
                                                              manager: self.manager,
                                                              isDisabled: !self.isEnabled(date: column),
                                                              isToday: self.isToday(date: column),
                                                              isSelected: self.isSpecialDate(date: column))
                                    CalendarCell(date: date,
                                                   cellHeight: cellHeight)
                                    .onTapGesture {
                                        self.dateTapped(date: column)
                                    }
                                } else {
                                    Text("")
                                        .frame(height: self.cellHeight)
                                        .frame(maxWidth: .infinity)
                                }
                                    
                                Spacer()
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .background(manager.colors.monthBackColor)
    }
    
    // MARK: - Actions -
    func isThisMonth(date: Date) -> Bool {
        return self.manager.calendar.isDate(date,
                                            equalTo: firstOfMonthForOffset(),
                                            toGranularity: .month)
    }
    
    func dateTapped(date: Date) {
        if self.isEnabled(date: date) {
            if self.manager.selectedDate != nil &&
                self.manager.calendar.isDate(self.manager.selectedDate!, inSameDayAs: date) {
                self.manager.selectedDate = nil
            } else {
                self.manager.selectedDate = date
            }
        }
    }
    
    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) {
            var columnArray = [Date]()
            for column in 0 ... 6 {
                let abc = self.getDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
        return rowArray
    }
    
    func getMonthHeader() -> String {
        let headerDateFormatter = DateFormatter()
        headerDateFormatter.calendar = manager.calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "LLLL",
                                                                  options: 0,
                                                                  locale: manager.calendar.locale)
        return headerDateFormatter.string(from: firstOfMonthForOffset()).capitalized
    }
    
    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthForOffset()
        let weekday = manager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - manager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset
        return manager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }
    
    func numberOfDays(offset : Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = manager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)
        return (rangeOfWeeks?.count)! * daysPerWeek
    }
    
    func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset
        return manager.calendar.date(byAdding: offset, to: firstDateMonth())!
    }
    
    func formatDate(date: Date) -> Date {
        let components = manager.calendar.dateComponents(calendarUnitYMD, from: date)
        return manager.calendar.date(from: components)!
    }
    
    func formatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = formatDate(date: referenceDate)
        let clampedDate = formatDate(date: date)
        return refDate == clampedDate
    }
    
    func firstDateMonth() -> Date {
        var components = manager.calendar.dateComponents(calendarUnitYMD, from: manager.minimumDate)
        components.day = 1
        return manager.calendar.date(from: components)!
    }
    
    // MARK: - Date Property Checkers -
    func isToday(date: Date) -> Bool {
        return formatAndCompareDate(date: date, referenceDate: Date())
    }
    
    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) ||
        isStartDate(date: date) ||
        isEndDate(date: date)
    }
    
    func isSelectedDate(date: Date) -> Bool {
        if manager.selectedDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: manager.selectedDate ?? Date())
    }
    
    func isStartDate(date: Date) -> Bool {
        if manager.startDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: manager.startDate)
    }
    
    func isEndDate(date: Date) -> Bool {
        if manager.endDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: manager.endDate)
    }
    
    func isOneOfDisabledDates(date: Date) -> Bool {
        return self.manager.disabledDatesContains(date: date)
    }
    
    func isEnabled(date: Date) -> Bool {
        let clampedDate = formatDate(date: date)
        if manager.calendar.compare(clampedDate, to: manager.minimumDate, toGranularity: .day) == .orderedAscending || manager.calendar.compare(clampedDate, to: manager.maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return !isOneOfDisabledDates(date: date)
    }
    
    func isStartDateAfterEndDate() -> Bool {
        if manager.startDate == nil {
            return false
        } else if manager.endDate == nil {
            return false
        } else if manager.calendar.compare(manager.endDate,
                                           to: manager.startDate,
                                           toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
}

struct CalendarMonth_Previews : PreviewProvider {
    static var previews: some View {
        let disabledDates = [Date().addingTimeInterval(60 * 60 * 24 * 3),
                             Date().addingTimeInterval(60 * 60 * 24 * 5),
                             Date().addingTimeInterval(60 * 60 * 24 * 10)] // Disabled 3, 5, 10 days ahead
        let minimumDate = Date() // Minimum today
        let maximumDate = Date().addingTimeInterval(60 * 60 * 24 * 365) // Year ahead
        let selectedDate = Date() // Optional, can be nil
        let uiColorSheme = UIColor.orange
        // Create manager
        let manager = CalendarManager(minimumDate: minimumDate,
                                        maximumDate: maximumDate,
                                        disabledDates: disabledDates,
                                        selectedDate: selectedDate,
                                        uiColorSheme: uiColorSheme)
        CalendarMonth(manager: manager,
                        monthOffset: 0)
    }
}

