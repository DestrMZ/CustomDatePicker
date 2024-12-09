//
//  Extensions.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 06.12.2024.
//

import SwiftUI


/// Класс настроек цветов для отображения элементов в календаре.
class ColorSettings {
    var textColor: Color = Color.primary // Цвет текста по умолчанию.
    var todayColor: Color = Color.red // Цвет для сегодняшнего дня.
    var selectedColor: Color = Color.white // Цвет для выбранной даты.
    var betweenColor: Color = Color.white // Цвет для диапазона дат между началом и концом.
    var disabledColor: Color = Color.gray // Цвет для недоступных дат.
    var todayBackColor: Color = Color.gray // Цвет фона для сегодняшнего дня.
    var textBackColor: Color = Color.clear // Цвет фона для текста.
    var disabledBackColor: Color = Color.clear // Цвет фона для недоступных дат.
    var selectedBackColor: Color = Color.blue // Цвет фона для выбранной даты.
    var betweenStartAndEndBackColor: Color = Color.init(.systemGray3) // Цвет фона для дат между началом и концом.
    var calendarBackColor: Color = Color.init(.systemGray6) // Цвет фона для календаря.
    var weekdayHeaderColor: Color = Color.secondary // Цвет для заголовка недели.
    var monthHeaderColor: Color = Color.primary // Цвет для заголовка месяца.
    var monthHeaderBackColor: Color = Color.clear // Цвет фона для заголовка месяца.
    var monthBackColor: Color = Color.clear // Цвет фона для месяца.
    var weekdayHeaderBackColor: Color = Color.clear // Цвет фона для заголовка недели.
}

/// Класс настроек шрифтов для различных элементов в календаре.
class FontSettings {
    var monthHeaderFont: Font = Font.body.bold() // Шрифт для заголовка месяца.
    var weekdayHeaderFont: Font = Font.caption // Шрифт для заголовка недели.
    var cellUnselectedFont: Font = Font.body // Шрифт для ячеек, не выбранных пользователем.
    var cellDisabledFont: Font = Font.body.weight(.light) // Шрифт для недоступных ячеек.
    var cellSelectedFont: Font = Font.body.bold() // Шрифт для выбранных ячеек.
    var cellTodayFont: Font = Font.body.bold() // Шрифт для сегодняшнего дня.
    var cellBetweenStartAndEndFont: Font = Font.body.bold() // Шрифт для дат между началом и концом диапазона.
}

/// Вспомогательные функции для работы с датами и календарем.
class Helper {
    
    /// Получает сокращенные наименования дней недели для текущего календаря.
    static func getWeekdayHeaders(calendar: Calendar) -> [String] {
        let weekdays = calendar.shortStandaloneWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1
        let adjustedWeekdays = Array(weekdays[firstWeekdayIndex...] + weekdays[..<firstWeekdayIndex])
        
        return adjustedWeekdays
    }
    
    /// Форматирует дату в строку, отображая только день месяца.
    static func formatDate(date: Date) -> String {
        return date.formatted(.dateTime.day())
    }
    
    /// Форматирует дату в строку по стандарту DateFormatter.
    static func stringFormatDate(date: Date) -> String {
        return date.formatted()
    }
    
    /// Извлекает номер месяца из переданной даты (от 1 до 12).
    static func getMonthDayFromDate(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        return components.month! - 1
    }
    
    /// Возвращает строку с наименованием месяца и года для заголовка.
    static func getMonthHeader(date: Date) -> String {
        let dateStyle = Date.FormatStyle()
            .year(.defaultDigits)
            .month(.wide)
        return date.formatted(dateStyle)
    }
    
    /// Возвращает количество месяцев между двумя датами.
    static func numberOfMonth(_ minDate: Date, _ maxDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.month], from: minDate, to: maxDate)
        return components.month! + 1
    }
    
    /// Находит последний день месяца для заданной даты.
    static func lastDayOfMonth(date: Date, calendar: Calendar = .current) -> Date {
        var components = calendar.dateComponents([.year, .month], from: date)
        
        components.setValue(1, for: .day)
        
        guard let startMonth = calendar.date(from: components) else {
            fatalError("Invalid date components!")
        }
        return calendar.date(byAdding: .month, value: -1, to: startMonth)?.addingTimeInterval(-86500) ?? startMonth
    }
}

/// Кастомная форма для создания округленных углов ячеек.
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity // Радиус округления углов.
    var corner: UIRectCorner = .allCorners // Углы, которые нужно округлить.
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner,  cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    
    func cornerRadius(_ radius: CGFloat, corner: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corner: corner))
    }
}

let daysPerWeek = 7
let cellWidth: CGFloat = 32


extension MonthView {
    
    // Проверяет, является ли текущая дата месяцем
    func isThisMonth(date: Date) -> Bool {
        return self.manager.calendar.isDate(date, equalTo: firstOfMonthOffset(), toGranularity: .month)
    }
    
    // Получает первую дату месяца
    func firstDateMonth() -> Date {
        var components = manager.calendar.dateComponents(calendarUnitYMD, from: manager.minimumDate)
        components.day = 1  // Устанавливаем первый день месяца
        return manager.calendar.date(from: components)!
    }
    
    // Получает первую дату месяца с учетом смещения
    func firstOfMonthOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset  // Применяем смещение для текущего месяца
        return manager.calendar.date(byAdding: offset, to: firstDateMonth())!
    }
    
    // Форматирует дату, исключая день, чтобы получить только год и месяц
    func formatDate(date: Date) -> Date {
        let components = manager.calendar.dateComponents(calendarUnitYMD, from: date)
        return manager.calendar.date(from: components)!
    }
    
    // Сравнивает дату с эталонной
    func formatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = formatDate(date: referenceDate)
        let clampedDate = formatDate(date: date)
        return refDate == clampedDate
    }
    
    // Возвращает количество дней в месяцах между двумя датами
    func numberOfDays(offset: Int) -> Int {
        let firstOfMonth = firstOfMonthOffset() // Получаем первую дату месяца с учетом смещения
        let rangeOfWeeks = manager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)  // Определяем диапазон недель месяца
        return (rangeOfWeeks?.count)! * daysPerWeek // Возвращаем количество дней в месяце
    }
    
    // Проверяет, является ли дата началом выбранного диапазона
    func isStartDate(date: Date) -> Bool {
        if manager.startDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: manager.startDate ?? Date())
    }
    
    // Проверяет, является ли дата концом выбранного диапазона
    func isEndDate(date: Date) -> Bool {
        if manager.endDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: manager.endDate ?? Date())
    }
    
    // Проверяет, лежит ли дата между началом и концом выбранного диапазона
    func isBeetweenStartAndEnd(date: Date) -> Bool {
        if manager.startDate == nil || manager.endDate == nil {
            return false
        } else if manager.calendar.compare(date, to: manager.startDate ?? Date(), toGranularity: .day) == .orderedAscending {
            return false
        } else if manager.calendar.compare(date, to: manager.endDate ?? Date(), toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    // Проверяет, доступна ли дата для выбора (не меньше минимальной и не больше максимальной)
    func isEnabled(date: Date) -> Bool {
        let clampedDate = formatDate(date: date)
        if manager.calendar.compare(clampedDate, to: manager.minimumDate, toGranularity: .day) == .orderedAscending ||
           manager.calendar.compare(clampedDate, to: manager.maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return !isOneOfDisabledDates(date: date)  // Проверяем, не является ли дата в списке недоступных
    }
    
    // Проверяет, является ли дата недоступной
    func isOneOfDisabledDates(date: Date) -> Bool {
        return self.manager.isDateDisabled(date)  // Проверяем с помощью менеджера, доступна ли дата
    }
    
    // Проверяет, если дата начала находится после даты конца, то возвращает false
    func isStartDateAfterEndDate() -> Bool {
        if manager.startDate == nil || manager.endDate == nil {
            return false
        } else if manager.calendar.compare(manager.endDate ?? Date(), to: manager.startDate ?? Date(), toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }
    
    // Проверяет, является ли дата сегодняшним днем
    func isToday(date: Date) -> Bool {
        return formatAndCompareDate(date: date, referenceDate: Date())  // Сравниваем с сегодняшней датой
    }
    
    // Проверяет, является ли дата специальной (например, выбранной пользователем)
    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) || isStartDate(date: date) || isEndDate(date: date) // Проверяем, выбрана ли эта дата
    }
    
    // Проверяет, является ли дата выбранной пользователем
    func isSelectedDate(date: Date) -> Bool {
        if manager.selectedDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: manager.selectedDate ?? Date())
    }
    
    // Обрабатывает событие нажатия на дату
    func dateTapped(date: Date) {
        if self.isEnabled(date: date) {
            if isStartDate {
                self.manager.startDate = date
                self.manager.endDate = nil
                isStartDate = false
            } else {
                self.manager.endDate = date
                if self.isStartDateAfterEndDate() {
                    self.manager.endDate = nil
                    self.manager.startDate = nil
                }
                isStartDate = true
            }
        }
    }
    
    // Возвращает дату для конкретного индекса в месяце
    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstDateMonth()  // Получаем первую дату месяца
        let weekday = manager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - manager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset  // Вычисляем смещение для текущей даты
        
        return manager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!  // Возвращаем полученную дату
    }
    
    // Создает и возвращает массив дат для всего месяца
    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()  // Массив строк, каждая строка — это неделя
        
        // Заполняем месяц
        for row in 0..<(numberOfDays(offset: monthOffset) / 7) {
            var columbArray: [Date] = []  // Массив для одной недели
            for column in 0...6 {
                let index = (row * 7) + column
                if index >= numberOfDays(offset: monthOffset) {
                    break  // Прерываем, если индекс выходит за пределы месяца
                }
                let abc = self.getDateAtIndex(index: index)
                columbArray.append(abc)  // Добавляем в текущую неделю
            }
            if !columbArray.isEmpty {
                rowArray.append(columbArray)  // Добавляем неделю в месяц, если она не пуста
            }
        }
        return rowArray
    }
    
    // Получает строку заголовка месяца
    func getMonthHeader() -> String {
        Helper.getMonthHeader(date: firstOfMonthOffset())  // Используем вспомогательную функцию для получения строки месяца
    }
}
