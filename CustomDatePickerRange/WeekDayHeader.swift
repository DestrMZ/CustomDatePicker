//
//  WeekDayHeader.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 09.12.2024.
//

import SwiftUI

struct WeekDayHeader: View {
    
    var manager: CalendarManager
    
    var body: some View {
        VStack(spacing: 8) {
            WeekdayHeaderView(manager: manager)
                .padding(.horizontal)
                .padding(.top)
            Divider()
        }
    }
}

#Preview {
    WeekDayHeader(manager: CalendarManager())
}
