//
//  ViewController.swift
//  Peach
//
//  Created by Василий on 30.10.2023.
//

import SwiftUI

struct ViewController: View {

    // MARK: - Properties

    @ObservedObject var rkManager: RKManager

    @State var isExpanded: Bool = false

    @State var viewHeight: CGFloat = 100

    var body: some View {
        Group {
            List {
                ForEach(0..<numberOfMonths()) { index in
                    RKMonth(
                        rkManager: self.rkManager,
                        monthOffset: index
                    )
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            HStack {
                ExpandedSwiftUIView()
                    .frame(maxWidth: .infinity, minHeight: 200) // Устанавливаем ширину и высоту
                    .background(.white)
                    .cornerRadius(16, corners: [.topLeft, .topRight])
                    .onTapGesture {
                        print("Сжимаем/увеличиваем вью")
                    }
            }
            .shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 0)
        }
    }

    // MARK: - Instance methods

    func numberOfMonths() -> Int {
        return rkManager.calendar.dateComponents(
            [.month],
            from: rkManager.minimumDate,
            to: RKMaximumDateMonthLastDay()).month! + 1
    }

    func RKMaximumDateMonthLastDay() -> Date {
        var components = rkManager.calendar.dateComponents(
            [.year, .month, .day],
            from: rkManager.maximumDate
        )
        components.month! += 1
        components.day = 0

        return rkManager.calendar.date(from: components)!
    }
}
