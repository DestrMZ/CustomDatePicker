//
//  DellCell.swift
//  CustomDatePickerRange
//
//  Created by Ivan Maslennikov on 07.12.2024.
//

import Foundation
import SwiftUI

/// Отображает ячейку календаря с учетом стилей и состояния.
struct DayCell: View {
    
    var calendarDate: CalendarDate
    var cellWidth: CGFloat
    
    /// Определяет углы для закругления ячейки.
    var corners: UIRectCorner {
        if calendarDate.isStartDate {
            return [.topLeft, .bottomLeft]
        } else if calendarDate.isEndDate {
            return [.topRight, .bottomRight]
        } else {
            return []
        }
    }
    
    /// Радиус закругления углов ячейки.
    var radius: CGFloat {
        calendarDate.isEndDate || calendarDate.isStartDate ? cellWidth / 2 : 0
    }
    
    var body: some View {
        Text(calendarDate.getText())
            .font(calendarDate.font)
            .foregroundColor(calendarDate.getTextColor()) // Исправлено с `foregroundStyle`
            .frame(width: cellWidth, height: cellWidth)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(calendarDate.getBackgroundColor())
                    .clipShape(RoundedCornerShape(radius: radius, corners: corners))
            )
            .frame(maxWidth: .infinity, alignment: .center)
    }
}

/// Кастомная форма для закругления выбранных углов.
struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    Group {
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalendarManager(),
                isDisabled: false,
                isToday: false,
                isSelected: false,
                isBetweenStartAndEnd: false
            ),
            cellWidth: 32
        )
        .frame(width: 32, height: 32)
        DayCell(
            calendarDate: CalendarDate(
                date: Date(),
                manager: CalendarManager(),
                isDisabled: false,
                isToday: true,
                isSelected: false,
                isBetweenStartAndEnd: false
            ),
            cellWidth: 32
        )
        .frame(width: 32, height: 32)
    }
}
