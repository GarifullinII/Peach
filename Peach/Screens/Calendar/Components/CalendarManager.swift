//
//  CalendarManager.swift
//  Peach
//
//  Created by Василий on 30.10.2023.
//

import SwiftUI

final class CalendarManager: ObservableObject {

    // MARK: - Properties

    @Published var calendar = Calendar.current

    @Published var dayModelDataSource: [DayModel] = []

    @Published var selectDate: Date?

    @Published var minimumDate: Date = Date()
    @Published var maximumDate: Date = Date()

    @Published var selectedDate: Date! = nil
    @Published var startDate: Date! = nil
    @Published var endDate: Date! = nil

    // MARK: - Initializers

    init() {
//        let user = UserDefaultsManager.shared.load(UserModel.self, Config.userModelKey.rawValue)
        // Загружаем пользователя из CoreData
        print(">>DEBUG: CalendarManager.init - загружаем пользователя из CoreData")
        let user = CoreDataManager.shared.loadUserModel()
        
        if let user = user {
            print(">>DEBUG: CalendarManager.init - пользователь загружен, дата начала цикла: \(user.startCycleDate?.description ?? "nil")")
        } else {
            print(">>DEBUG: CalendarManager.init - пользователь не найден, используем текущую дату")
        }
        
        self.minimumDate = user?.startCycleDate ?? Date()

        let maximumDate = calendar.date(byAdding: .year, value: 1, to: minimumDate) ?? Date()
        self.maximumDate = maximumDate

        makeInitialModel(from: minimumDate, to: maximumDate)
    }

    // MARK: - Instance methods

    // получаем день
    func getDay(date: Date) -> DayModel? {
        let dateComponentsInput = calendar.dateComponents([.day, .month, .year], from: date)
        if let day = dayModelDataSource.first(where: { $0.dateComponents == dateComponentsInput }) {
            return day
        } else {
            return nil
        }
    }

    // создаем изначальную модель
    func makeInitialModel(from startDate: Date, to endDate: Date) {
//        let user = UserDefaultsManager.shared.load(UserModel.self, Config.userModelKey.rawValue)
        // Загружаем пользователя из CoreData
        let user = CoreDataManager.shared.loadUserModel()
        let periodDuration = user?.cycleDuration ?? 0
        let allDates = getAllDates(minimumDate: startDate, maximumDate: endDate)
        let cycleDuration = 28
        let ovulationDay = 13

        // известные месячные
        for i in 0..<periodDuration {
            let date = calendar.date(byAdding: .day, value: i, to: minimumDate) ?? Date()
            appendDayModel(date: date, isMenstrual: true, cycleDayCount: i + 1)
        }

        for i in 0..<allDates.count {
            if i % cycleDuration == 0 {
                // этот цикл задает будущие циклы
                for dayCounter in (0..<periodDuration) {
                    let date = calendar.date(byAdding: .day, value: dayCounter, to: allDates[i]) ?? Date()
                    appendDayModel(date: date, isMenstrualForecast: true, cycleDayCount: dayCounter + 1)
                }
                // эта дата задает все дни овуляции
                let ovulationDate = calendar.date(byAdding: .day, value: ovulationDay, to: allDates[i])!
                appendDayModel(date: ovulationDate, isOvulation: true, cycleDayCount: i)
            } else {
                let cycleAnotherDatesIndex = (i % cycleDuration) + 1
                dayModelDataSource.append(
                    DayModel(
                        date: allDates[i],
                        isDefault: true,
                        cycleDayCount: cycleAnotherDatesIndex)
                )
            }
        }
    }

    // получаем все даты на весь период
    private func getAllDates(minimumDate: Date, maximumDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = minimumDate

        while currentDate <= maximumDate {
            dates.append(currentDate)

            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        return dates
    }

    private func appendDayModel(
        date: Date,
        isMenstrual: Bool=false,
        isOvulation: Bool=false,
        isMenstrualForecast: Bool=false,
        cycleDayCount: Int
    ) {
        let model = DayModel(
            date: date,
            isMenstrual: isMenstrual,
            isOvulation: isOvulation,
            isMenstrualForecast: isMenstrualForecast,
            cycleDayCount: cycleDayCount
        )
        dayModelDataSource.append(model)
    }
}


// создаем массив с диапазоном дат
//    func createPeriodDays(from startDate: Date, byAdding component: Calendar.Component, count: Int) -> [Day] {
//        var dates: [Day] = []
//        var currentDate = startDate
//
//        for _ in 0..<count {
//            if let newDate = calendar.date(byAdding: component, value: 1, to: currentDate) {
//                let day = Day(date: newDate)
//                dates.append(day)
//                currentDate = newDate
//            }
//        }
//        return dates
//    }

//    func selectedDatesFindIndex(date: Date) -> Int? {
//        return self.selectedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
//    }

//    func disabledDatesContains(date: Date) -> Bool {
//        if let _ = self.disabledDates.first(where: { calendar.isDate($0, inSameDayAs: date) }) {
//            return true
//        }
//        return false
//    }

//    func disabledDatesFindIndex(date: Date) -> Int? {
//        return self.disabledDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: date) })
//    }
