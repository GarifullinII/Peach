//
//  Month.swift
//  Peach
//
//  Created by Василий on 30.10.2023.
//

import SwiftUI

struct RKMonth: View {

    // MARK: - Properties

    @ObservedObject var rkManager: RKManager

    @State var showTime = false

    var monthsArray: [[Date]] {
        monthArray()
    }

    let monthOffset: Int

    private let calendarUnitYMD = Set<Calendar.Component>([.year, .month, .day])

    private let daysPerWeek = 7

    private let cellWidth = CGFloat(32)

    var body: some View {
        VStack(alignment: HorizontalAlignment.center, spacing: 10){
            Text(getMonthHeader()).foregroundColor(self.rkManager.colors.monthHeaderColor)
                .frame(width: 130, height: 30)
                .background(self.rkManager.colors.monthPink)
                .cornerRadius(15)
                .padding(20)
                .font(.system(size: 16, weight: .medium))
            RKWeekdayHeader(rkManager: self.rkManager)
            Divider()
            VStack(alignment: .leading, spacing: 15) {
                ForEach(monthsArray, id:  \.self) { row in
                    HStack() {
                        ForEach(row, id:  \.self) { column in
                            HStack() {
                                Spacer()
                                if self.isThisMonth(date: column) {
                                    RKCell(rkDate: RKDate(
                                        date: column,
                                        rkManager: self.rkManager,
                                        isDisabled: !self.isEnabled(date: column),
                                        isToday: self.isToday(date: column),
                                        isSelected: self.isSpecialDate(date: column),
                                        isBetweenStartAndEnd: self.isBetweenStartAndEnd(date: column)),
                                        cellWidth: self.cellWidth)
                                        .onTapGesture { self.dateTapped(date: column) }
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

    // MARK: - Instance methods

     func isThisMonth(date: Date) -> Bool {
         return self.rkManager.calendar.isDate(
            date,
            equalTo: firstOfMonthForOffset(),
            toGranularity: .month
         )
     }

    func dateTapped(date: Date) {
        if self.isEnabled(date: date) {
            switch self.rkManager.mode {
            case 0:
                if self.rkManager.selectedDate != nil &&
                    self.rkManager.calendar.isDate(self.rkManager.selectedDate, inSameDayAs: date) {
                    self.rkManager.selectedDate = nil
                } else {
                    self.rkManager.selectedDate = date
                }
            case 1:
                self.rkManager.startDate = date
                self.rkManager.endDate = nil
                self.rkManager.mode = 2
            case 2:
                self.rkManager.endDate = date
                if self.isStartDateAfterEndDate() {
                    self.rkManager.endDate = nil
                    self.rkManager.startDate = nil
                }
                self.rkManager.mode = 1
            case 3:
                if self.rkManager.selectedDatesContains(date: date) {
                    if let ndx = self.rkManager.selectedDatesFindIndex(date: date) {
                        rkManager.selectedDates.remove(at: ndx)
                    }
                } else {
                    self.rkManager.selectedDates.append(date)
                }
            default:
                self.rkManager.selectedDate = date
            }
        }
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
        headerDateFormatter.calendar = rkManager.calendar
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "MMMM",
            options: 0, locale: rkManager.calendar.locale
        )

        return headerDateFormatter.string(from: firstOfMonthForOffset()).capitalized
    }

    func getDateAtIndex(index: Int) -> Date {
        let firstOfMonth = firstOfMonthForOffset()
        let weekday = rkManager.calendar.component(.weekday, from: firstOfMonth)
        var startOffset = weekday - rkManager.calendar.firstWeekday
        startOffset += startOffset >= 0 ? 0 : daysPerWeek
        var dateComponents = DateComponents()
        dateComponents.day = index - startOffset

        return rkManager.calendar.date(byAdding: dateComponents, to: firstOfMonth)!
    }

    func numberOfDays(offset : Int) -> Int {
        let firstOfMonth = firstOfMonthForOffset()
        let rangeOfWeeks = rkManager.calendar.range(of: .weekOfMonth, in: .month, for: firstOfMonth)

        return (rangeOfWeeks?.count)! * daysPerWeek
    }

    func firstOfMonthForOffset() -> Date {
        var offset = DateComponents()
        offset.month = monthOffset

        return rkManager.calendar.date(byAdding: offset, to: RKFirstDateMonth())!
    }

    func RKFormatDate(date: Date) -> Date {
        let components = rkManager.calendar.dateComponents(calendarUnitYMD, from: date)

        return rkManager.calendar.date(from: components)!
    }

    func RKFormatAndCompareDate(date: Date, referenceDate: Date) -> Bool {
        let refDate = RKFormatDate(date: referenceDate)
        let clampedDate = RKFormatDate(date: date)
        return refDate == clampedDate
    }

    func RKFirstDateMonth() -> Date {
        var components = rkManager.calendar.dateComponents(calendarUnitYMD, from: rkManager.minimumDate)
        components.day = 1

        return rkManager.calendar.date(from: components)!
    }

    // MARK: - Date Property Checkers

    func isToday(date: Date) -> Bool {
        return RKFormatAndCompareDate(date: date, referenceDate: Date())
    }

    func isSpecialDate(date: Date) -> Bool {
        return isSelectedDate(date: date) ||
            isStartDate(date: date) ||
            isEndDate(date: date) ||
            isOneOfSelectedDates(date: date)
    }

    func isOneOfSelectedDates(date: Date) -> Bool {
        return self.rkManager.selectedDatesContains(date: date)
    }

    func isSelectedDate(date: Date) -> Bool {
        if rkManager.selectedDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: rkManager.selectedDate)
    }

    func isStartDate(date: Date) -> Bool {
        if rkManager.startDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: rkManager.startDate)
    }

    func isEndDate(date: Date) -> Bool {
        if rkManager.endDate == nil {
            return false
        }
        return RKFormatAndCompareDate(date: date, referenceDate: rkManager.endDate)
    }

    func isBetweenStartAndEnd(date: Date) -> Bool {
        if rkManager.startDate == nil {
            return false
        } else if rkManager.endDate == nil {
            return false
        } else if rkManager.calendar.compare(date, to: rkManager.startDate, toGranularity: .day) == .orderedAscending {
            return false
        } else if rkManager.calendar.compare(date, to: rkManager.endDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return true
    }

    func isOneOfDisabledDates(date: Date) -> Bool {
        return self.rkManager.disabledDatesContains(date: date)
    }

    func isEnabled(date: Date) -> Bool {
        let clampedDate = RKFormatDate(date: date)
        if rkManager.calendar.compare(clampedDate, to: rkManager.minimumDate, toGranularity: .day) == .orderedAscending || rkManager.calendar.compare(clampedDate, to: rkManager.maximumDate, toGranularity: .day) == .orderedDescending {
            return false
        }
        return !isOneOfDisabledDates(date: date)
    }

    func isStartDateAfterEndDate() -> Bool {
        if rkManager.startDate == nil {
            return false
        } else if rkManager.endDate == nil {
            return false
        } else if rkManager.calendar.compare(
            rkManager.endDate,
            to: rkManager.startDate,
            toGranularity: .day
        ) == .orderedDescending {
            return false
        }
        return true
    }
}
