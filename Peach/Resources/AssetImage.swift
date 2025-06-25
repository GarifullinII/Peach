//
//  AssetImage.swift
//  Peach
//
//  Created by Василий on 05.09.2023.
//

import UIKit

enum AssetImage: String {
    case chat = "chat_icon"
    case calendar = "calendar_icon"
    case сalendar_selected = "сalendar_selected_icon"
    case profile = "profile_icon"
    case chat_selected = "chat_selected_icon"
    case backArrow = "backArrow_icon"
    case pro = "pro_icon"
    case avatar = "avatar_icon"
    case profilePremium = "profilePremuim_icon"
    case reportPDF = "reportPDF_icon"
    case right_arrow = "right_arrow_icon"
    case peach = "peach_icon"
    case checkBox = "checkBox_icon"
    case checkBox_fill = "checkBox_fill_icon"
    case onboarding_first = "onboarding_first"
    case onboarding_second = "onboarding_second"
    case onboarding_third = "onboarding_third"
    case page_left_icon = "page_left_icon"
    case page_center_icon = "page_center_icon"
    case page_right_icon = "page_right_icon"
    case timeLine_first = "timeLine_first_icon"
    case timeLine_second = "timeLine_second_icon"
    case timeLine_third = "timeLine_third_icon"
    case calendar_small_icon = "calendar_small_icon"
    case drop_arrow_icon = "drop_arrow_icon"
    case close_button_icon = "close_button_icon"
    case apiSender_icon = "apiSender_icon"
    case send_icon = "send_icon"
    case add_symptoms_small = "add_symptoms_small"
    case message_readed_icon = "message_readed_icon"
    case calendar_pink_frame = "calendar_pink_frame"
    case calendar_purple_frame = "calendar_purple_frame"
    case calendar_white_frame = "calendar_white_frame"

    var image: UIImage {
        return UIImage(named: rawValue)!
    }
}
