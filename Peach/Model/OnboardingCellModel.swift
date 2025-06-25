//
//  OnboardingCellModel.swift
//  Peach
//
//  Created by Василий on 13.09.2023.
//

import UIKit

struct OnboardingCellModel {
    let image: UIImage
    let firstTitle: String
    let secondTitle: String
    let pageImage: UIImage

    static let onboarding: [Self] = [
        .init(
            image: AssetImage.onboarding_first.image,
            firstTitle: AssetString.track_your_cycle.text,
            secondTitle: AssetString.convenient_calendar.text,
            pageImage: AssetImage.page_left_icon.image
        ),
        .init(
            image: AssetImage.onboarding_second.image,
            firstTitle: AssetString.private_assistant.text,
            secondTitle: AssetString.assistant_will_answer.text,
            pageImage: AssetImage.page_center_icon.image
        ),
        .init(
            image: AssetImage.onboarding_third.image,
            firstTitle: AssetString.track_your_symptoms.text,
            secondTitle: AssetString.share_symptoms.text,
            pageImage: AssetImage.page_right_icon.image
        )
    ]
}
