//
//  DayModel.swift
//  Peach
//
//  Created by Василий on 08.11.2023.
//

import SwiftUI

// MARK: - Nested types

enum ViewState: Codable {
    case isMenstrual
    case isOvulation
    case isMenstruationForecast
    case `default`
}

struct DayModel {

    // MARK: - Properties

    let date: Date
    let dateComponents: DateComponents

    var state: ViewState {
        if isMenstrual {
            return .isMenstrual
        } else if isOvulation {
            return .isOvulation
        } else if isMenstrualForecast {
            return .isMenstruationForecast
        } else {
            return .default
        }
    }

    var isSelected: Bool
    var isMenstrual: Bool
    var isOvulation: Bool
    var isMenstrualForecast: Bool
    var isDefault: Bool
    var cycleDayCount: Int
    var symptoms: Symptoms?
    
    // MARK: - Initializer

    init(
        date: Date,
        isMenstrual: Bool=false,
        isOvulation: Bool=false,
        isMenstrualForecast:Bool=false,
        isDefault: Bool=false,
        isSelected: Bool=false,
        cycleDayCount: Int=0,
        symptoms: Symptoms?=nil
    ) {
        self.date = date
        self.isMenstrual = isMenstrual
        self.isOvulation = isOvulation
        self.isMenstrualForecast = isMenstrualForecast
        self.isDefault = isDefault
        self.isSelected = isSelected
        self.cycleDayCount = cycleDayCount
        self.symptoms = symptoms
        self.dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: date)
    }

    // MARK: - Instance methods

    func getText() -> String {
        return formatDate(date: date, calendar: Calendar.current)
    }

    func getBackgroundColor() -> Color {
        switch state {
        case .isMenstrual:
            return Color.mainPink
        case .isOvulation, .isMenstruationForecast:
            return isSelected ? Color.mainGray : Color.white
        case  .default:
            return Color.white
        }
    }

    func getTextColor() -> Color {
        switch state {
        case .isMenstrual:
            return Color.white
        case .isMenstruationForecast:
            return Color.mainPink
        case .isOvulation, .default:
            return Color.black
        }
    }

    private func formatDate(date: Date, calendar: Calendar) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "d"

        return stringFrom(date: date, formatter: formatter, calendar: calendar)
    }

    private func stringFrom(date: Date, formatter: DateFormatter, calendar: Calendar) -> String {
        if formatter.calendar != calendar {
            formatter.calendar = calendar
        }
        return formatter.string(from: date)
    }
}
