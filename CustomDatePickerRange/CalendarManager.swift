//
//  CalendarManager.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 07.12.2024.
//

import Foundation

/// Управляет состоянием календаря и конфигурацией для пользовательского выбора дат.
///

@Observable
class CalendarManager {
    
    var startDate: Date? = nil /// Начальная дата выбранного пользователем диапазона.
    var endDate: Date? = nil /// Конечная дата выбранного пользователем диапазона.
    var todayDate: Date? = Date() /// Текущая дата.
    var selectedDates: [Date] = [] /// Массив выбранных дат.
    var disabledDates: [Date] = [] /// Список конкретных дат, которые недоступны для выбора.
    var calendar: Calendar = .current /// Календарь, используемый для вычислений дат.
    var minimumDate: Date = Date() /// Наиболее ранняя дата, доступная для выбора.
    var maximumDate: Date = Date() /// Наиболее поздняя дата, доступная для выбора.

    var isFutureSelectionEnabled: Bool = false // Выбор будущих дат, либо прошлых
    
    var colors: ColorSettings = ColorSettings()
    var fonts: FontSettings = FontSettings()
    
    
    /// Инициализирует новый экземпляр `CalendarManager`.
    init(
        calendar: Calendar = .current,
        minimumDate: Date,
        maximumDate: Date,
        selectedDates: [Date] = [],
        isFutureSelectionEnabled: Bool
    ) {
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.isFutureSelectionEnabled = isFutureSelectionEnabled
        self.updateRange()
    }
    
    /// Проверяет, является ли указанная дата недоступной для выбора.
    /// - Параметр date: Дата, которую нужно проверить.
    /// - Возвращает: `true`, если дата недоступна, иначе `false`.
    func isSelectedDateDisabled(date: Date) -> Bool {
        if self.disabledDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
            return true
        }
        return false
    }

    /// Генерирует заголовок для месяца на основе смещения от минимальной даты.
    /// - Параметр monthOffset: Смещение в месяцах от минимальной даты.
    /// - Возвращает: Форматированную строку, представляющую месяц и год.
    func monthHeader(forMonthOffset monthOffset: Int) -> String {
        if let date = firstDateForMonthOffset(monthOffset) {
            return Helper.getMonthHeader(date: date)
        } else {
            return ""
        }
    }
    
    /// Рассчитывает первую дату месяца для заданного смещения.
    /// - Параметр offset: Смещение в месяцах от минимальной даты.
    /// - Возвращает: Первую дату месяца.
    func firstDateForMonthOffset(_ offset: Int) -> Date? {
        var offsetComponents = DateComponents()
        offsetComponents.month = offset
        return calendar.date(byAdding: offsetComponents, to: firstDateOfMonth())
    }
    
    /// Рассчитывает первую дату текущего месяца на основе минимальной даты.
    /// - Возвращает: Первую дату текущего месяца.
    func firstDateOfMonth() -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: minimumDate)
        components.day = 1
        return calendar.date(from: components) ?? Date()
    }
    
    func updateRange() {
        if isFutureSelectionEnabled {
            minimumDate = Date()
            maximumDate = calendar.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        } else {
            minimumDate = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
            maximumDate = Date()
        }
    }
}
