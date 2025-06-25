//
//  CalendarViewModel.swift
//  Peach
//
//  Created by Василий on 18.09.2023.
//

import Foundation
import Combine
import HorizonCalendar

protocol CalendarViewModel: AnyObject {
    init()
    var input: PassthroughSubject<CalendarInput, Never> { get }
    var output: PassthroughSubject<CalendarOutput, Never> { get }
    var viewIsIncreased: Bool { get }
}

final class CalendarViewModelImpl: BaseViewModel, CalendarViewModel {

    // MARK: - Nested types

    enum DateType {
        case year
        case month
        case day
    }

    // MARK: - Properties

    var input = PassthroughSubject<CalendarInput, Never>()
    var output = PassthroughSubject<CalendarOutput, Never>()
    var dateRange = CurrentValueSubject<Set<ClosedRange<Date>>, Never>([])
    var viewIsIncreased: Bool = false

    // MARK: - Initializers

    override init() {
        super.init()

        getCycleRange()
        bind()
    }

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    func makeDate(for state: DateType) -> Int {
        let date = Date()
        let dateFormatter = DateFormatter()
        switch state {
        case .year:
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: date)
            return Int(year) ?? 2023
        case .month:
            dateFormatter.dateFormat = "MM"
            let month = dateFormatter.string(from: date)
            return Int(month)!
        case .day:
            dateFormatter.dateFormat = "dd"
            let day = dateFormatter.string(from: date)
            return Int(day)!
        }
    }

    private func bind() {
        input.sink { [weak self] input in
            switch input {
            case .showSymptoms:
                self?.output.send(.showSymptoms)
            default:
                break
            }
        }.store(in: &cancellables)
    }

    private func getCycleRange() {
        let user = UserDefaultsManager.shared.load(
            UserModel.self,
            Config.userModelKey.rawValue
        )

        let cycleDuration = user?.cycle_duration
        let currentDate = user?.start_cycle_date ?? Date()
        var dateComponent = DateComponents()
        dateComponent.day = (cycleDuration ?? 0) - 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()

        dateRange.value.insert(currentDate...futureDate)
    }

    private func setCurrentDay() -> Date {
        let calendar = Calendar.current
        let year = makeDate(for: .year)
        let month = makeDate(for: .month)
        let day = makeDate(for: .day)

        return calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }
}
