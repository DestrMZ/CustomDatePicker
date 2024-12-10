//
//  WeekdayHeaderView.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 08.12.2024.
//

import SwiftUI

/// A view displaying the header for weekdays in a calendar.
struct WeekdayHeaderView: View {
    
    /// The calendar manager providing configuration for the calendar.
    var manager: CalendarManager
    
    /// An array of localized weekday names (e.g., "Mon", "Tue").
    var weekdays: [String] {
        Helper.getWeekdayHeaders(calendar: manager.calendar)  // Получаем локализованные названия дней недели
    }
    
    var body: some View {
        HStack(alignment: .center) {
            // Рендерим каждый день недели как текстовый элемент, равномерно распределяя их по ширине
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .font(manager.font.weekdayHeaderFont)  // Применяем кастомный шрифт для заголовков дней недели
                    .frame(maxWidth: .infinity)  // Равномерно распределяем каждый день по ширине
            }
        }
        .foregroundStyle(manager.colors.weekdayHeaderColor)  // Применяем цвет текста
        .background(manager.colors.weekdayHeaderBackColor)  // Применяем фоновый цвет для заголовка
    }
}

#Preview {
    // Превью для WeekdayHeaderView с использованием календаря по умолчанию
    WeekdayHeaderView(manager: CalendarManager())
}

