//
//  CalendarManager.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 07.12.2024.
//

import Foundation

/// Управляет состоянием календаря и конфигурацией для пользовательского выбора дат.
@Observable
class CalendarManager {
    
    /// Текущая выбранная дата.
    var selectedDate: Date? = nil
    
    /// Начальная дата выбранного диапазона.
    var startDate: Date? = nil
    
    /// Конечная дата выбранного диапазона.
    var endDate: Date? = nil
    
    /// Календарь, используемый для вычислений дат.
    var calendar: Calendar = .current
    
    /// Наиболее ранняя дата, доступная для выбора.
    var minimumDate: Date = Date()
    
    /// Наиболее поздняя дата, доступная для выбора.
    var maximumDate: Date = Date()
    
    /// Список конкретных дат, которые недоступны для выбора.
    var disabledDates: [Date] = []
    
    /// Дата, после которой все даты становятся недоступными.
    var disabledAfterDate: Date?
    
    /// Настройки цветов для календаря.
    var colors: ColorSettings = ColorSettings()
    
    /// Настройки шрифтов для календаря.
    var font: FontSettings = FontSettings()
    
    /// Инициализирует новый экземпляр `CalendarManager`.
    init(
        selectedDate: Date? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        calendar: Calendar = .current,
        minimumDate: Date = Date(),
        maximumDate: Date = Date(),
        disabledAfterDate: Date? = nil,
        colors: ColorSettings = ColorSettings(),
        font: FontSettings = FontSettings()
    ) {
        self.selectedDate = selectedDate
        self.startDate = startDate
        self.endDate = endDate
        self.calendar = calendar
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.disabledAfterDate = disabledAfterDate
        self.colors = colors
        self.font = font
    }
    
    /// Проверяет, является ли указанная дата недоступной для выбора.
    /// - Параметр date: Дата, которую нужно проверить.
    /// - Возвращает: `true`, если дата недоступна, иначе `false`.
    func isDateDisabled(_ date: Date) -> Bool {
        if let disabledAfterDate = disabledAfterDate, date > disabledAfterDate {
            return true
        } else {
            return disabledDates.contains { calendar.isDate($0, inSameDayAs: date) }
        }
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
}
