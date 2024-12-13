//
//  WeekDayHeader.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 09.12.2024.
//

import SwiftUI

struct WeekDayHeader: View {
    
    var calendarManager: CalendarManager
    
    var body: some View {
        VStack(spacing: 8) {
            WeekdayHeaderView(calendarManager: calendarManager)
                .padding(.horizontal)
                .padding(.top)
            Divider()
        }
    }
}

#Preview {
    WeekDayHeader(calendarManager: CalendarManager(minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), isFutureSelectionEnabled: false))
}
