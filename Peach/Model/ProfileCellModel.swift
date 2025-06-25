//
//  ProfileCellModel.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit

struct ProfileCellModel {
    let image: UIImage
    let title: String

    static let model: [Self] = [
        .init(
            image: AssetImage.chat.image,
            title: AssetString.private_assistant.text
        ),
        .init(
            image: AssetImage.reportPDF.image,
            title: AssetString.health_report.text
        ),
    ]
}
