//
//  CalendarWeekdayHeader.swift
//  Calendar
//
//  Created by Roman R. on 5/30/22.
//  Copyright © 2022 r@resrom.com All rights reserved.
//

import SwiftUI

struct CalendarWeekdayHeader : View {
    // MARK: - Properties -
    var manager: CalendarManager
     
    // MARK: - View -
    var body: some View {
        HStack(alignment: .center) {
            ForEach(self.getWeekdayHeaders(calendar: self.manager.calendar),
                    id: \.self) { weekday in
                Text(weekday.uppercased())
                    .font(.body)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(self.manager.colors.weekdayHeaderColor)
                
            }
        }
        .background(manager.colors.weekdayHeaderBackColor)
    }
    
    func getWeekdayHeaders(calendar: Calendar) -> [String] {
        let formatter = DateFormatter()
        var weekdaySymbols = formatter.shortStandaloneWeekdaySymbols
        let weekdaySymbolsCount = weekdaySymbols?.count ?? 0
        for _ in 0 ..< (1 - calendar.firstWeekday + weekdaySymbolsCount){
            let lastObject = weekdaySymbols?.last
            weekdaySymbols?.removeLast()
            weekdaySymbols?.insert(lastObject!, at: 0)
        }
        return weekdaySymbols ?? []
    }
}

struct CalendarWeekdayHeader_Previews : PreviewProvider {
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
        
        CalendarWeekdayHeader(manager: manager)
    }
}

