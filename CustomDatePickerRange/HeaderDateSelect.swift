//
//  HeaderDateSelect.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 14.12.2024.
//

import SwiftUI

struct HeaderDateSelect: View {
    
    var calendarMananger: CalendarManager
    
    var body: some View {
        
        HStack {
            
            VStack {
                Text("Дата начала")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                Text("\(Helper.formattedDate(calendarMananger.startDate))")
                    .font(.headline)
            }
            
            Spacer()
            
            VStack {
                Text("Дата окончания")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                Text("\(Helper.formattedDate(calendarMananger.endDate))")
                    .font(.headline)
            }
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    HeaderDateSelect(calendarMananger: CalendarManager(minimumDate: Date(), maximumDate: Date(), isFutureSelectionEnabled: false))
}
