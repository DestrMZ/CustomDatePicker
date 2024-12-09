//
//  RangeCalendar.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 09.12.2024.
//

import SwiftUI

struct RangeCalendar: View {
    
    var manager: CalendarManager  // Менеджер календаря, который управляет настройками календаря и диапазоном дат
    
    // Вычисляет общее количество месяцев для отображения на основе диапазона дат
    var numberOfMonths: Int {
        Helper.numberOfMonth(manager.minimumDate, manager.maximumDate)  // Используем вспомогательную функцию для вычисления числа месяцев
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Заголовок с днями недели
            WeekDayHeader(manager: manager)
            
            ScrollViewReader { reader in
                // Вертикальная прокручиваемая область для навигации по месяцам
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 32) {
                        // Генерируем представление для каждого месяца в диапазоне
                        ForEach(0..<numberOfMonths, id: \.self) { index in
                            // Каждый месяц отображается с помощью компонента MonthView
                            MonthView(manager: manager, monthOffset: index)
                        }
                    }
                    .padding()  // Добавляем отступы вокруг всех месяцев
                }
                .onAppear {
                    // Прокручиваем к месяцу с начальной датой, если она есть
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let date = manager.startDate {
                            let monthOffset = Helper.getMonthDayFromDate(date: date) // Получаем смещение месяца
                            reader.scrollTo(monthOffset, anchor: .center)  // Прокручиваем к нужному месяцу
                        }
                    }
                }
            }
        }
        // Устанавливаем фоновый цвет для календаря, игнорируя безопасные зоны экрана
        .background(manager.colors.calendarBackColor.ignoresSafeArea())
    }
}

#Preview {
    // Превью компонента RangeCalendar с настройкой диапазона дат (от двух месяцев до текущей даты и два месяца после)
    RangeCalendar(manager: CalendarManager(
        minimumDate: Date().addingTimeInterval(-60 * 60 * 24 * 30 * 2),  // Два месяца назад
        maximumDate: Date().addingTimeInterval(60 * 60 * 25 * 30)))  // Два месяца вперед
}
