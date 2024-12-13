//
//  RangeCalendar.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 09.12.2024.
//

import SwiftUI

struct RangeCalendar: View {
    
    var calendarManager: CalendarManager
    
    // Вычисляет общее количество месяцев для отображения на основе диапазона дат
    var numberOfMonths: Int {
        Helper.numberOfMonth(calendarManager.minimumDate, calendarManager.maximumDate)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок с днями недели
            WeekDayHeader(calendarManager: calendarManager)
            
            ScrollViewReader { reader in
                // Вертикальная прокручиваемая область для навигации по месяцам
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 32) {
                        // Генерируем представление для каждого месяца в диапазоне
                        ForEach(0..<numberOfMonths, id: \.self) { index in
                            // Каждый месяц отображается с помощью компонента MonthView
                            MonthView(calendarManager: calendarManager, monthOffset: index)
                        }
                    }
                    .padding()
                }
                .onAppear {
//                    Прокручиваем к месяцу с начальной датой, если она есть
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                       if let date = calendarManager.todayDate {
                           let monthOffset = Helper.getMonthOffsetForCurrent(calendar: calendarManager, date: date)
                           reader.scrollTo(monthOffset, anchor: .center)  // Прокручиваем к нужному месяцу
                           print("\(date)")
                           print("\(monthOffset)")
                       }
                   }
               }
            }
        }
        // Устанавливаем фоновый цвет для календаря, игнорируя безопасные зоны экрана
        .background(calendarManager.colors.textBackColor.ignoresSafeArea())
    }
}

#Preview {
    // Превью компонента RangeCalendar с настройкой диапазона дат (от двух месяцев до текущей даты и два месяца после)
    RangeCalendar(calendarManager: CalendarManager(
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2),  // Два месяца назад
        maximumDate: Date().addingTimeInterval(60 * 60 * 25 * 30), isFutureSelectionEnabled: false))  // Два месяца вперед
}

 
