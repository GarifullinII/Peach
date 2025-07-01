//
//  SignInEvents.swift
//  Peach
//
//  Created by Василий on 14.09.2023.
//

import Foundation

enum SignInEvents {
    case fillFromTopTF(String, Int)
    case fillFromBottomTF(String)
    case setDate(Date, Int)
    case saveModel
    case showAlert
}

enum SignInOutput {
    case showAlert
    case showInvalidAgeAlert
    case dismiss
    case showAgeAlert(title: String, message: String)
}
