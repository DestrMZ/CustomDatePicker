//
//  CalendarDate.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 07.12.2024.


import SwiftUI

/// Представляет одну дату в календаре с различными состояниями и свойствами.
struct CalendarDate {
    
    /// Дата, связанная с этой ячейкой календаря.
    var date: Date
    
    /// Менеджер календаря, предоставляющий конфигурацию и состояние.
    var manager: CalendarManager
    
    /// Указывает, является ли дата недоступной для выбора.
    var isDisabled: Bool = false
    
    /// Указывает, является ли дата сегодняшней.
    var isToday: Bool = false
    
    /// Указывает, выбрана ли эта дата.
    var isSelected: Bool = false
    
    /// Указывает, находится ли дата между начальной и конечной датами диапазона.
    var isBetweenStartAndEnd: Bool = false
    
    /// Конечная дата выбранного диапазона.
    var endDate: Date?
    
    /// Начальная дата выбранного диапазона.
    var startDate: Date?
    
    init(
        date: Date,
        manager: CalendarManager,
        isDisabled: Bool = false,
        isToday: Bool = false,
        isSelected: Bool = false,
        isBetweenStartAndEnd: Bool = false,
        endDate: Date? = nil,
        startDate: Date? = nil
    ) {
        self.date = date
        self.manager = manager
        self.isDisabled = isDisabled
        self.isToday = isToday
        self.isSelected = isSelected
        self.isBetweenStartAndEnd = isBetweenStartAndEnd
        self.endDate = endDate
        self.startDate = startDate
    }
    
    /// Указывает, является ли эта дата конечной датой диапазона.
    var isEndDate: Bool {
        date == endDate
    }
    
    /// Указывает, является ли эта дата начальной датой диапазона.
    var isStartDate: Bool {
        date == startDate
    }
    
    /// Возвращает текстовое представление даты.
    func getText() -> String {
        return Helper.formatDate(date: date)
    }
    
    /// Определяет цвет текста в зависимости от состояния даты.
    func getTextColor() -> Color {
        if isDisabled {
            return manager.colors.disabledColor
        } else if isSelected {
            return manager.colors.selectedColor
        } else if isToday {
            return manager.colors.todayColor
        } else if isBetweenStartAndEnd {
            return manager.colors.betweenColor //
        }
        return manager.colors.textColor
    }



    /// Определяет цвет фона в зависимости от состояния даты.
    func getBackgroundColor() -> Color {
        if isBetweenStartAndEnd {
            return manager.colors.betweenStartAndEndBackColor
        } else if isDisabled {
            return manager.colors.disabledBackColor
        } else if isSelected {
            return manager.colors.selectedBackColor
        }
        return manager.colors.textBackColor
    }



    /// Определяет шрифт в зависимости от состояния даты.
    var font: Font {
        if isDisabled {
            return manager.font.cellDisabledFont
        } else if isSelected {
            return manager.font.cellSelectedFont
        } else if isToday {
            return manager.font.cellTodayFont
        } else if isBetweenStartAndEnd {
            return manager.font.cellBetweenStartAndEndFont
        }
        return manager.font.cellUnselectedFont
    }
}
