//
//  CalendarView.swift
//  Peach
//
//  Created by Василий on 18.09.2023.
//

import UIKit
import HorizonCalendar
import SnapKit
import Combine

final class CalendarVieW: BaseContentView<CalendarViewModelImpl> {

    // MARK: - Nested Types

    private enum CalendarSelection {
        case singleDay(Day)
        case dayRange(DayRange)
    }

    // MARK: - Properties

    var singleDaySelectionHandler: ((Day) -> Void)?

    lazy var dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = calendar.locale
        dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "EEEE, MMM d, yyyy",
            options: 0,
            locale: calendar.locale ?? Locale.current)
        return dateFormatter
    }()

    private lazy var calendarView = CalendarView(initialContent: makeContent())

    private lazy var expandedView = ExpandedView(viewModel: ExpandedViewModelImpl())

    private var calendarSelection: CalendarSelection?

    private var selectedDate: Date?

    private let calendar = Calendar.current

    // MARK: - Initializers

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    override func setUp() {
        super.setUp()

        setupCalendarView()
        calendarViewActions()
    }

    override func bind() -> [AnyCancellable] {
        super.bind() + [
            expandedView.viewModel.input.sink(receiveValue: { [weak self] input in
                switch input {
                case .changeHeight:
                    self?.updateAppearence()
                case .decreaseHeight:
                    self?.decreaseHeight()
                case .showSymptoms:
                    self?.viewModel.input.send(.showSymptoms)
                }
            })
        ]
    }

    // меняем высоту вью динамически
    private func updateAppearence() {
        UIView.animate(withDuration: 0.3) {
            self.expandedView.snp.updateConstraints { [weak self] (make) in
                guard let self else { return }

                if self.viewModel.viewIsIncreased == true {
                    self.viewModel.viewIsIncreased = false
                    make.height.equalTo(100)
                } else {
                    self.viewModel.viewIsIncreased = true
                    make.height.equalTo(350)
                }
            }
            self.layoutIfNeeded()
            super.updateConstraints()
        }
    }

    // просто уменьшаем высоту
    private func decreaseHeight() {
        UIView.animate(withDuration: 0.3) {
            self.expandedView.snp.updateConstraints { [weak self] (make) in
                guard let self else { return }

                if self.viewModel.viewIsIncreased == true {
                    self.viewModel.viewIsIncreased = false
                    make.height.equalTo(100)
                }
            }
            self.layoutIfNeeded()
            super.updateConstraints()
        }
    }

    // реагируем на касания
    private func calendarViewActions() {
//        calendarView.daySelectionHandler = { [weak self] day in
//            guard let self else { return }
//
//            self.selectedDate = self.calendar.date(from: day.components)
//            self.calendarView.setContent(self.makeContent())
//
////            self.singleDaySelectionHandler?(day)
//        }
    }

    // установка вью
    private func setupCalendarView() {
        add {
            calendarView
            expandedView
        }

        calendarView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }

        expandedView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(16)
        }
    }

    // эта функция полностью отвечает за отображение календаря
    private func makeContent() -> CalendarViewContent {
        let startDate = calendar.date(from: DateComponents(
            year: viewModel.makeDate(for: .year),
            month: viewModel.makeDate(for: .month),
            day: viewModel.makeDate(for: .day)))!
        let endDate = calendar.date(from: DateComponents(year: 2030, month: 12, day: 31))!

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()))
        .interMonthSpacing(60)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
        .daysOfTheWeekRowSeparator(options: .systemStyleSeparator)

        .dayItemProvider { [weak self, calendar, dayDateFormatter] day in

            var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive

            let date = calendar.date(from: day.components)
            if date == self?.selectedDate {
                invariantViewProperties.backgroundShapeDrawingConfig.borderColor = .mainPink
                invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .clear
            }

            let accessibilityLabel = self?.dayDateFormatter.string(from: day.components.date ?? Date())

            return DayView.calendarItemModel(
                invariantViewProperties: invariantViewProperties,
                content: .init(
                    dayText: "\(day.day)",
                    accessibilityLabel: accessibilityLabel,
                    accessibilityHint: nil))
        }

        .dayRangeItemProvider(for: viewModel.dateRange.value) { dayRangeLayoutContext in
            DayRangeIndicatorView.calendarItemModel(
                invariantViewProperties: .init(),
                content: .init(
                    framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
        }
    }
}
