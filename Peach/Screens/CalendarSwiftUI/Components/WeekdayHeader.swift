//
//  WeekdayHeader.swift
//  Peach
//
//  Created by Василий on 30.10.2023.
//

import SwiftUI

struct RKWeekdayHeader : View {

    // MARK: - Properties

    var rkManager: RKManager

    var body: some View {
        HStack(alignment: .center) {
            ForEach(self.getWeekdayHeaders(calendar: self.rkManager.calendar), id: \.self) { weekday in
                Text(weekday)
                    .font(.system(size: 12, weight: .medium))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .foregroundColor(self.rkManager.colors.weekdayHeaderColor)
            }
        }.background(rkManager.colors.weekdayHeaderBackColor)
    }

    // MARK: - Instance methods

    func getWeekdayHeaders(calendar: Calendar) -> [String] {
        let formatter = DateFormatter()
        var weekdaySymbols = formatter.shortStandaloneWeekdaySymbols
        let weekdaySymbolsCount = weekdaySymbols?.count ?? 0

        for _ in 0 ..< (1 - calendar.firstWeekday + weekdaySymbolsCount){
            let lastObject = weekdaySymbols?.last
            weekdaySymbols?.removeLast()
            weekdaySymbols?.insert(lastObject!, at: 0)
        }

        return weekdaySymbols ?? []
    }
}
