//
//  CalendarView.swift
//  Calendar
//
//  Created by Roman R. on 5/30/22.
//  Copyright © 2022 r@resrom.com All rights reserved.
//

import SwiftUI

public struct CalendarView: View {
    // MARK: - Properties -
    var titleText: String!
    var rightButtonText: String!
    var doneButtonText: String!
    @ObservedObject var manager: CalendarManager
    var dateSelected: ((Date?) -> Void)
    // MARK: - Init -
    public init(titleText: String,
                rightButtonText: String,
                doneButtonText: String,
                manager: CalendarManager,
                dateSelected: @escaping ((Date?) -> Void)) {
        self.titleText = titleText
        self.rightButtonText = rightButtonText
        self.doneButtonText = doneButtonText
        self.manager = manager
        self.dateSelected = dateSelected
    }
    // MARK: - View -
    public var body: some View {
        Group {
            ZStack {
                Text(titleText)
                    .padding()
                    .font(.headline)
                Spacer()
                HStack(alignment: .center,
                       spacing: 0) {
                    Button {
                        dateSelected(nil)
                    } label: {
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .foregroundColor(manager.colors.activeBackColor)
                            .frame(width: 32, height: 32)
                            .background(manager.colors.todayBackColor.opacity(0.15))
                            .clipShape(Circle())
                    }
                    Spacer()
                    Button {
                        manager.selectedDate = nil
                    } label: {
                        Text(rightButtonText)
                            .font(.headline)
                            .foregroundColor(manager.colors.activeBackColor)
                    }
                }
                       .padding(.leading, 15)
                       .padding(.trailing, 15)
                       .frame(maxWidth: .infinity)
            }
            CalendarWeekdayHeader(manager: self.manager)
                .padding()
            List {
                ForEach(0..<numberOfMonths(), id: \.self) { index in
                    CalendarMonth(manager: self.manager,
                                    monthOffset: index)
                    .withoutSeparators()
                }
            }
            .listStyle(PlainListStyle())
            
            VStack {
                Text("")
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .border(.gray.opacity(0.25), width: 0.5)
                    .shadow(color: .gray, radius: 3, x: 0, y: -3)
                    .padding(.bottom, 15)
                    .opacity(0.5)
                
                Button(action: {
                    dateSelected(manager.selectedDate)
                }) {
                    HStack {
                        Spacer()
                        Text(doneButtonText)
                            .font(.headline)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .padding()
                .disabled(manager.selectedDate == nil)
                .frame(maxWidth: .infinity)
                .background(manager.selectedDate == nil ?  manager.colors.disabledColor : manager.colors.activeBackColor)
                .cornerRadius(15)
                
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .frame(maxWidth: .infinity)
            }
            
            
        }
    }
    
    // MARK: - Data Source -
    func numberOfMonths() -> Int {
        return manager.calendar.dateComponents([.month], from: manager.minimumDate, to: maximumDateMonthLastDay()).month! + 1
    }
    
    func maximumDateMonthLastDay() -> Date {
        var components = manager.calendar.dateComponents([.year, .month, .day], from: manager.maximumDate)
        components.month! += 1
        components.day = 0
        
        return manager.calendar.date(from: components)!
    }
}

struct TableWithoutSeparatorsModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .listRowSeparator(.hidden)
        } else {
            content
        }
    }
}

extension View {
    func withoutSeparators() -> some View {
        modifier(TableWithoutSeparatorsModifier())
    }
}

struct CalendarView_Previews : PreviewProvider {
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
        //manager.colors.activeBackColor = Color(.blue)
        CalendarView(titleText: "Дата приема",
                       rightButtonText: "Сбросить",
                       doneButtonText: "Готово",
                       manager: manager,
                       dateSelected: { dateSelected in
            print(dateSelected ?? "")
        })
    }
}

