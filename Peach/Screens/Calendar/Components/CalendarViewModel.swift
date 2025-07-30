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
    
    var calendarManager: CalendarManager?
    
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
    
    func savePeriodDateChanges() {
        guard let selectedDay = selectedDay,
              let calendarManager = calendarManager else { return }
        
        // Загружаем текущую модель пользователя
        var user = UserDefaultsManager.shared.load(UserModel.self, Config.userModelKey.rawValue) ?? UserModel()
        
        // Обновляем дату начала цикла на выбранную дату
        user.start_cycle_date = selectedDay.date
        
        // Сохраняем обновленную модель
        UserDefaultsManager.shared.save(user, Config.userModelKey.rawValue)
        SymptomsManager.shared.setCurrentUser(user.id)
        
        // Выводим обновленные данные
        print("Сохраненные данные UserModel ===")
        print("Имя: \(user.name ?? "Не указано")")
        print("Возраст: \(user.age ?? 0)")
        print("Дата рождения: \(user.birth_date ?? Date())")
        print("Дата цикла: \(user.start_cycle_date ?? Date())")
        print("Длительность цикла: \(user.cycle_duration ?? 0)")
        
        // Обновляем minimumDate в CalendarManager
        calendarManager.minimumDate = selectedDay.date
        
        // Пересоздаем модель данных календаря с новой датой начала цикла
        let maximumDate = calendarManager.calendar.date(byAdding: .year, value: 1, to: selectedDay.date) ?? Date()
        calendarManager.maximumDate = maximumDate
        
        // Очищаем старые данные и создаем новые
        calendarManager.dayModelDataSource.removeAll()
        calendarManager.makeInitialModel(from: selectedDay.date, to: maximumDate)
        
        // Закрываем модальное окно
        isModelAreRefreshing = false
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
