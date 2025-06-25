//
//  ViewController.swift
//  Peach
//
//  Created by Василий on 30.10.2023.
//

import SwiftUI

struct ViewController: View {

    // MARK: - Properties

    @ObservedObject var manager: CalendarManager

    @EnvironmentObject var viewModel: CalendarViewModel

    @State private var isExpanded = false
    
    var body: some View {
        Group {
            ZStack {
                List {
                    ForEach(Array(0..<numberOfMonths()), id: \.self) { index in
                        Month(
                            manager: self.manager,
                            monthOffset: index
                        )
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .opacity(viewModel.isModelAreRefreshing ? 0.5 : 1)

                if viewModel.isModelAreRefreshing {
                    VStack {
                        Spacer()
                        HStack(spacing: 10) {
                            Button {
                                viewModel.isModelAreRefreshing = false
                            } label:
                            { Text(AssetString.cancel.text)
                                    .frame( maxWidth: .infinity, alignment: .center)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 42)
                            .background(Color.monthPink)
                            .foregroundColor(.mainPink)
                            .cornerRadius(16)

                            Button {
                                print(1)
                                // update data and model
                            } label:
                            { Text(AssetString.save.text)
                                    .frame( maxWidth: .infinity, alignment: .center)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 42)
                            .background(Color.mainPink)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.bottom, .leading, .trailing])
                        .padding(.bottom, 30)
                    }
                    .ignoresSafeArea(.all)
                }
            }

            if !viewModel.isModelAreRefreshing {
                if isExpanded {
                    HStack {
                        ExpandedSmallView()
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(.white)
                            .cornerRadius(16, corners: [.topLeft, .topRight])
                            .animation(.easeInOut(duration: 0.3), value: isExpanded)
                            .animation(.easeOut, value: 0.3)
                            .onTapGesture {
                                isExpanded.toggle()
                            }

                    }
                    .frame(minHeight: 50)
                    .shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 0)
                } else {
                    HStack {
                        ExpandedView()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(.white)
                            .cornerRadius(16, corners: [.topLeft, .topRight])
                            .animation(.easeInOut(duration: 0.3), value: isExpanded)
                            .onTapGesture {
                                isExpanded.toggle()
                            }
                    }
                    .shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 0)
                }
            }
        }
    }

    // MARK: - Instance methods

    func numberOfMonths() -> Int {
        return manager.calendar.dateComponents(
            [.month],
            from: manager.minimumDate,
            to: maximumDateMonthLastDay()).month! + 1
    }

    func maximumDateMonthLastDay() -> Date {
        var components = manager.calendar.dateComponents(
            [.year, .month, .day],
            from: manager.maximumDate
        )
        components.month! += 1
        components.day = 0

        return manager.calendar.date(from: components)!
    }
}
