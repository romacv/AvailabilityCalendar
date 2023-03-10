//
//  CalendarManager.swift
//  Calendar
//
//  Created by Roman R. on 5/30/22.
//  Copyright © 2022 r@resrom.com All rights reserved.
//

import SwiftUI

public class CalendarManager : ObservableObject {
    // MARK: - Properties -
    @Published var minimumDate: Date = Date()
    @Published var maximumDate: Date = Date()
    @Published var disabledDates: [Date] = [Date]()
    @Published var selectedDate: Date?
    @Published var startDate: Date! = nil
    @Published var endDate: Date! = nil
    @Published var calendar = Calendar.current
    var colors = CalendarColorSettings()
    
    // MARK: - Init -
    public init(minimumDate: Date,
                maximumDate: Date,
                disabledDates: [Date],
                selectedDate: Date?,
                uiColorSheme: UIColor) {
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.disabledDates = disabledDates
        self.selectedDate = selectedDate
        colors.activeBackColor = Color(uiColorSheme)
    }
    
    // MARK: - Actions -
    func disabledDatesContains(date: Date) -> Bool {
        if let _ = self.disabledDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }
    
    func disabledDatesFindIndex(date: Date) -> Int? {
        return self.disabledDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
    }
}
