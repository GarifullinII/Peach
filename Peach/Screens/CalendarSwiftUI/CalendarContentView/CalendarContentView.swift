//
//  CalendarContentView.swift
//  Peach
//
//  Created by Василий on 30.10.2023.
//

import SwiftUI

struct CalendarContentView : View {

    @EnvironmentObject var viewModel: CalendarViewModelSwiftUI

    var multiSelectionManager = RKManager(calendar: Calendar.current, minimumDate: Date(), maximumDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())!, mode: 3)

    var body: some View {
        VStack {
            ViewController(rkManager: self.multiSelectionManager)
                .navigationBarHidden(true)
        }
        .onAppear(perform: setup)
    }

    func datesView(dates: [Date]) -> some View {
        ScrollView (.horizontal) {
            HStack {
                ForEach(dates, id: \.self) { date in
                    Text(self.getTextFromDate(date: date))
                }
            }
        }.padding(.horizontal, 15)
    }

    func setup() {
        // example of pre-setting selected dates
        let testOnDates = [Date().addingTimeInterval(60*60*24*6),
                           Date().addingTimeInterval(60*60*24*7),
                           Date().addingTimeInterval(60*60*24*8),
                           Date().addingTimeInterval(60*60*24*9)]
        multiSelectionManager.selectedDates.append(contentsOf: testOnDates)

        multiSelectionManager.colors.weekdayHeaderColor = Color.black
        multiSelectionManager.colors.monthHeaderColor = Color.black
        multiSelectionManager.colors.textColor = Color.black
        multiSelectionManager.colors.disabledColor = Color.gray
    }

    func getTextFromDate(date: Date!) -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return date == nil ? "" : formatter.string(from: date)
    }
}
