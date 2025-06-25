//
//  PaymentCellModel.swift
//  Peach
//
//  Created by Василий on 12.09.2023.
//

import Foundation

struct PaymentCellModel {
    let id: Int
    let paymentPerYear: String
    let paymentPerMonth: String
    let isSelected: Bool

    static var payments: [Self] {
        if Locale.current.isEnglish {
            return [
                .init(id: 0,
                      paymentPerYear: "Year • 25 $",
                      paymentPerMonth: "2 $/ month",
                      isSelected: true),
                .init(id: 1,
                      paymentPerYear: "",
                      paymentPerMonth: "5 $ ₽/ month",
                      isSelected: false)
            ]
        } else {
            return [
                .init(id: 0,
                      paymentPerYear: "Год • 2500 ₽",
                      paymentPerMonth: "199 ₽/ мес",
                      isSelected: true),
                .init(id: 1,
                      paymentPerYear: "",
                      paymentPerMonth: "499 ₽/ мес",
                      isSelected: false)
            ]
        }
    }
}
