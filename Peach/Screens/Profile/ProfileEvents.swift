//
//  ProfileEvents.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import Foundation

enum ProfileInput {
    case premiumTap
    case assistantTap
    case healthReportTap
    case signOut
}

enum ProfileOutput {
    case showPremium
    case showAssiatant
    case showHealthReport
    case goToSetNameAndAge // исправить потом, название уж больно дебильное!
}
