//
//  Month.swift
//  Peach
//
//  Created by Василий on 30.10.2023.
//

import SwiftUI

struct Month: View {

    // MARK: - Properties

    @ObservedObject var manager: CalendarManager

    @EnvironmentObject var viewModel: CalendarViewModel

    var monthsArray: [[Date]] {
        monthArray()
    }

    let monthOffset: Int

    private let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])

    private let daysPerWeek = 7

    private let cellWidth = CGFloat(32)

    var body: some View {
        VStack(alignment: HorizontalAlignment.center, spacing: 10){
            Text(getMonthHeader()).foregroundColor(.black)
                .frame(width: 130, height: 30)
                .background(Color.monthPink)
                .cornerRadius(15)
                .padding(20)
                .font(.system(size: 16, weight: .medium))
            RKWeekdayHeader(manager: manager)
            Divider()
            VStack(alignment: .leading, spacing: 15) {
                ForEach(monthsArray, id:  \.self) { row in
                    HStack() {
                        ForEach(row, id:  \.self) { column in
                            HStack() {
                                Spacer()
                                if self.isThisMonth(date: column) {
                                    // пофиксить этот бред!
                                    DayCell(day: DayModel(
                                        date: column,
                                        isMenstrual: self.getDayModel(date: column).isMenstrual,
                                        isOvulation: self.getDayModel(date: column).isOvulation,
                                        isMenstrualForecast: self.getDayModel(date: column).isMenstrualForecast,
                                        isSelected: self.isSelected(date: column),
                                        symptoms: self.getSymptoms(date: column)),
                                         cellWidth: cellWidth)
                                    .onTapGesture {
                                        self.dateTapped(date: column)
                                    }
                                    .onAppear(perform: makeDefaultDay)
                                } else {
                                    Text("").frame(width: self.cellWidth, height: self.cellWidth)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }

    // MARK: -

    func dateTapped(date: Date) {
        manager.selectDate = manager.selectDate == date ? nil : date
        viewModel.changeView(
            selectedDay: self.getDayModel(date: manager.selectDate == nil ? Date() : date)
        )
        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(.success)
        }
    }

    func isSelected(date: Date) -> Bool {
        return manager.calendar.isDate(date, inSameDayAs: manager.selectDate ?? Date())
    }

    func makeDefaultDay() {
        if viewModel.selectedDay == nil {
            viewModel.changeView(selectedDay: self.getDayModel(date: Date()))
            manager.selectDate = Date()
        }
    }

    func getDayModel(date: Date) -> DayModel {
        let components = Calendar.current.dateComponents([.day, .month, .year], from: date)
        return manager.dayModelDataSource.first(
            where: { $0.dateComponents == components }
        ) ?? DayModel(date: Date())
    }

    func getSymptoms(date: Date) -> Symptoms? {
        return SymptomsManager.shared.get(date: date)
    }

    // MARK: - Instance methods

     func isThisMonth(date: Date) -> Bool {
         return self.manager.calendar.isDate(
            date,
            equalTo: firstOfMonthForOffset(),
            toGranularity: .month
         )
     }

    func monthArray() -> [[Date]] {
        var rowArray = [[Date]]()
        for row in 0 ..< (numberOfDays(offset: monthOffset) / 7) {
            var columnArray = [Date]()
            for column in 0 ... 6 {
                let abc = self.getDateAtIndex(index: (row * 7) + column)
                columnArray.append(abc)
            }
            rowArray.append(columnArray)
        }
        return rowArray
    }

    func getMonthHeader() -> String {
        let headerDateFormatter = DateFormatter()
        headerDateFormatter.calendar = manager.calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "MMMM",
            options: 0, locale: manager.calendar.locale
        )

        return headerDateFormatter.string(from: firstOfMonthForOffset()).capitalized
    }

    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthForOffset()
        let weekday = manager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - manager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset

        return manager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }

    func numberOfDays(offset : Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = manager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)

        return (rangeOfWeeks?.count)! * daysPerWeek
    }

    func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset

        return manager.calendar.date(byAdding: offset, to: firstDateMonth())!
    }

    func formatDate(date: Date) -> Date {
        let components = manager.calendar.dateComponents(calendarUnitYMD, from: date)

        return manager.calendar.date(from: components)!
    }

    func formatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = formatDate(date: referenceDate)
        let clampedDate = formatDate(date: date)
        return refDate == clampedDate
    }

    func firstDateMonth() -> Date {
        var components = manager.calendar.dateComponents(calendarUnitYMD, from: manager.minimumDate)
        components.day = 1

        return manager.calendar.date(from: components)!
    }

    // MARK: - Date Property Checkers

    func isStartDate(date: Date) -> Bool {
        if manager.startDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: manager.startDate)
    }

    func isEndDate(date: Date) -> Bool {
        if manager.endDate == nil {
            return false
        }
        return formatAndCompareDate(date: date, referenceDate: manager.endDate)
    }

    func isBetweenStartAndEnd(date: Date) -> Bool {
        if manager.startDate == nil {
            return false
        } else if manager.endDate == nil {
            return false
        } else if manager.calendar.compare(date, to: manager.startDate, toGranularity: .day) == .orderedAscending {
            return false
        } else if manager.calendar.compare(date, to: manager.endDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }

    func isStartDateAfterEndDate() -> Bool {
        if manager.startDate == nil {
            return false
        } else if manager.endDate == nil {
            return false
        } else if manager.calendar.compare(
            manager.endDate,
            to: manager.startDate,
            toGranularity: .day
        ) == .orderedDescending {
            return false
        }
        return true
    }
}


//    func isOneOfDisabledDates(date: Date) -> Bool {
//        return self.manager.disabledDatesContains(date: date)
//    }
//
//    func isEnabled(date: Date) -> Bool {
//        let clampedDate = formatDate(date: date)
//        if manager.calendar.compare(clampedDate, to: manager.minimumDate, toGranularity: .day) == .orderedAscending || manager.calendar.compare(clampedDate, to: manager.maximumDate, toGranularity: .day) == .orderedDescending {
//            return false
//        }
//        return !isOneOfDisabledDates(date: date)
//    }

//    func isToday(date: Date) -> Bool {
//        return formatAndCompareDate(date: date, referenceDate: Date())
//    }

//    func isSpecialDate(date: Date) -> Bool {
//        return isSelectedDate(date: date) ||
//            isStartDate(date: date) ||
//            isEndDate(date: date) ||
//            return isOneOfSelectedDates(date: date)
//    }

//    func isOneOfSelectedDates(date: Date) -> Bool {
//        return self.manager.selectedDatesContains(date: date)
//    }

//    func isSelectedDate(date: Date) -> Bool {
//        if manager.selectedDate == nil {
//            return false
//        }
//        return formatAndCompareDate(date: date, referenceDate: manager.selectedDate)
//    }


//func dateTapped(date: Date) {
//        if self.isEnabled(date: date) {
//            switch self.rkManager.mode {
//            case 0:
//                if self.rkManager.selectedDate != nil &&
//                    self.rkManager.calendar.isDate(self.rkManager.selectedDate, inSameDayAs: date) {
//                    self.rkManager.selectedDate = nil
//                } else {
//                    self.rkManager.selectedDate = date
//                }
//            case 1:
//                self.rkManager.startDate = date
//                self.rkManager.endDate = nil
//                self.rkManager.mode = 2
//            case 2:
//                self.rkManager.endDate = date
//                if self.isStartDateAfterEndDate() {
//                    self.rkManager.endDate = nil
//                    self.rkManager.startDate = nil
//                }
//                self.rkManager.mode = 1
//            case 3:
//                if self.manager.selectedDatesContains(date: date) {
//                    if let ndx = self.manager.selectedDatesFindIndex(date: date) {
//                        manager.selectedDates.remove(at: ndx)
//                    }
//                } else {
//                    self.manager.selectedDates.append(date)
//                }
//            default:
//                self.rkManager.selectedDate = date
//            }
//        }
//    }
