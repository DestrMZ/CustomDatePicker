//
//  ContentView.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 06.12.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var calendarManager = CalendarManager(calendar: .current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365), isFutureSelectionEnabled: false)
    
    var body: some View {
        VStack {
            HeaderDateSelect(calendarMananger: calendarManager)
            RangeCalendar(calendarManager: calendarManager)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
