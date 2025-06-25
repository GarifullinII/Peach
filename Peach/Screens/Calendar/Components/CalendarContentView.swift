//
//  CalendarContentView.swift
//  Peach
//
//  Created by Василий on 30.10.2023.
//

import SwiftUI

struct CalendarContentView : View {

    // MARK: - Properties

    @EnvironmentObject var viewModel: CalendarViewModel

    var calendarManager = CalendarManager()

    var body: some View {
        VStack {
            ViewController(manager: self.calendarManager)
                .navigationBarHidden(true)
        }
    }
}
