//
//  SignInCellModel.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import UIKit

struct SignInCellModel {
    let id: Int
    let step: String
    let timelineImage: UIImage
    let title: String

    static let signIn: [Self] = [
        .init(id: 0,
              step: AssetString.step_one.text,
              timelineImage: AssetImage.timeLine_first.image,
              title: AssetString.lets_meet.text),
        .init(id: 1,
              step: AssetString.step_two.text,
              timelineImage: AssetImage.timeLine_second.image,
              title: AssetString.lets_meet.text),
        .init(id: 2,
              step: AssetString.step_three.text,
              timelineImage: AssetImage.timeLine_third.image,
              title: AssetString.when_cycle_started.text),
    ]
}
