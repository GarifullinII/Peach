//
//  PremiumAccountEvents.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import Foundation

enum PremiumInput {
    case paymentTap
    case dismiss
}

enum PremiumOutput {
    case showPayment(Int) // пока неизвестно, что показывать
    case dismsiss
}
