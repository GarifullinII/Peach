//
//  CalendarViewModel.swift
//  Peach
//
//  Created by Василий on 07.11.2023.
//

import Foundation
import SwiftUI

final class CalendarViewModel: ObservableObject {

    // MARK: - Properties

    var showSymptomsHandler: (() -> Void)?

    var hideTabBarHandler: ((Bool) -> Void)?

    @Published var selectedDay: DayModel?

    @Published var isModelAreRefreshing: Bool = false {
        didSet {
            hideTabBarHandler?(isModelAreRefreshing)
        }
    }
    
    @Published var image = UIImage()
    @Published var title = String()
    @Published var subTitle = String()
    @Published var color = Color(.white)
    @Published var buttonText = String()

    // MARK: - Instance methods

    func showSymptomsAction() {
        showSymptomsHandler?()
    }

    func changeView(selectedDay: DayModel) {
        self.selectedDay = selectedDay
        switch selectedDay.state {
        case .isMenstrual:
            image = AssetImage.calendar_pink_frame.image
            title = AssetString.period.text
            color = Color.mainPink
            buttonText = AssetString.change_period_date.text
            subTitle = String(selectedDay.cycleDayCount) + " " + "день"
        case .isOvulation:
            image = AssetImage.calendar_purple_frame.image
            title = AssetString.ovulation.text
            subTitle = "Один день"
            color = Color.mainPurple
            buttonText = AssetString.mark_your_period.text
        case .isMenstruationForecast:
            image = AssetImage.calendar_white_frame.image
            title = "Прогноз месячных"
            subTitle = String(selectedDay.cycleDayCount) + " " + "день"
            color = Color.mainPurple
            buttonText = AssetString.mark_your_period.text
        case .default:
            if selectedDay.cycleDayCount == 0 {
                image = AssetImage.calendar_white_frame.image
                title = "Отметьте месячные"
                subTitle = "Пока пусто"
                color = Color.mainPurple
                buttonText = AssetString.mark_your_period.text
            } else {
                image = AssetImage.calendar_white_frame.image
                title = "Текущий цикл"
                subTitle = String(selectedDay.cycleDayCount) + " " + "день"
                color = Color.mainPurple
                buttonText = AssetString.mark_your_period.text
            }
        }
    }
}
