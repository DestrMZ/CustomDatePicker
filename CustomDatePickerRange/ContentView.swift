//
//  ContentView.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 06.12.2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var manager = CalendarManager(calendar: .current, minimumDate: Date(), maximumDate: Date().addingTimeInterval(60*60*24*365))
    
    var body: some View {
        VStack {
            
            RangeCalendar(manager: manager)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
