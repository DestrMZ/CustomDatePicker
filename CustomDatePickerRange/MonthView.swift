import SwiftUI

struct MonthView: View {
    
    @State var isStartDate: Bool = false  // Состояние для отслеживания начала диапазона даты
    @State var showTime: Bool = false  // Состояние для отображения времени (если требуется)
    
    var manager: CalendarManager  // Менеджер, управляющий календарем
    let monthOffset: Int  // Смещение месяца относительно текущего
    
    /// Набор компонентов для извлечения компонентов даты (год, месяц, день)
    let calendarUnitYMD: Set<Calendar.Component> = [.year, .month, .day]
    
    /// Массив, представляющий недели, каждая неделя содержит дни месяца.
     var monthsArray: [[Date]] {
        return monthArray()  // Массив дат для месяца, создается с помощью метода monthArray
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Заголовок месяца
            Text(getMonthHeader())  // Получаем строку заголовка месяца
                .font(manager.font.monthHeaderFont)  // Шрифт заголовка
                .foregroundColor(manager.colors.monthHeaderColor)  // Цвет заголовка
                .padding(.leading)  // Отступ слева
            
            // Ячейки календаря
            VStack(alignment: .leading, spacing: 5) {
                // Для каждой недели (строки) в месяце
                ForEach(monthsArray, id: \.self) { row in
                    HStack(spacing: 0) {  // Для каждой ячейки в строке
                        ForEach(row, id: \.self) { date in
                            cellView(for: date)  // Отображаем ячейку для каждой даты
                        }
                    }
                }
            }
        }
        .background(manager.colors.monthHeaderBackColor)  // Цвет фона для месяца
    }
}

#Preview {
    MonthView(manager: CalendarManager(), monthOffset: 0)  // Превью компонента с начальными значениями
}

extension MonthView {
    
    /// Отображает ячейку для указанной даты
    func cellView(for date: Date) -> some View {
        if isThisMonth(date: date) {  // Проверяем, является ли дата текущим месяцем
            return AnyView(
                DayCell(
                    calendarDate: CalendarDate(  // Создаем объект DayCell с соответствующими данными
                        date: date,
                        manager: manager,
                        isDisabled: !isEnabled(date: date),  // Проверяем, доступна ли дата
                        isToday: isToday(date: date),  // Проверяем, является ли дата сегодняшней
                        isSelected: isSpecialDate(date: date),  // Проверяем, выбрана ли дата
                        isBetweenStartAndEnd: isBeetweenStartAndEnd(date: date),  // Проверяем, находится ли дата в диапазоне
                        endDate: manager.endDate,
                        startDate: manager.startDate
                    ),
                    cellWidth: cellWidth  // Ширина ячейки
                )
                .onTapGesture {  // Обрабатываем нажатие на ячейку
                    dateTapped(date: date)
                }
            )
        } else {
            // Если дата не в текущем месяце, просто возвращаем пустой текст
            return AnyView(
                Text("")
                    .frame(maxWidth: .infinity, alignment: .center)
            )
        }
    }
}
