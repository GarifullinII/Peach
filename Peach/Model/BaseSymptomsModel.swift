//
//  Symptoms.swift
//  Peach
//
//  Created by Василий on 22.09.2023.
//

import Foundation

protocol BaseSymptomsInput {
    var title: String { get }
    var type: SymptomCellType { get }
}

struct BaseSymptom: BaseSymptomsInput {
    let title: String
    let type: SymptomCellType
}

struct BaseSymptomsModel {
    let symptoms: [BaseSymptom]
    let discharge: [BaseSymptom]
    let profuseBleeding: [BaseSymptom]

    static var model: [Self] = [
        .init(
            symptoms: [
                .init(title: AssetString.normal.text, type: .pink),
                .init(title: AssetString.headache.text, type: .pink),
                .init(title: AssetString.fatigue.text, type: .pink),
                .init(title: AssetString.pimples.text, type: .pink),
                .init(title: AssetString.pain_in_the_lower_abdomen.text, type: .pink),
                .init(title: AssetString.bloating.text, type: .pink),
                .init(title: AssetString.nausea.text, type: .pink),
                .init(title: AssetString.food_cravings.text, type: .pink),
                .init(title: AssetString.constipation.text, type: .pink),
                .init(title: AssetString.diarrhea.text, type: .pink),
                .init(title: AssetString.itching_in_the_vagina.text, type: .pink)
            ],
            discharge: [
                .init(title: AssetString.no_discharge.text, type: .blue),
                .init(title: AssetString.with_blood.text, type: .blue),
                .init(title: AssetString.sticky.text, type: .blue),
                .init(title: AssetString.watery.text, type: .blue),
                .init(title: AssetString.white.text, type: .blue)
            ], profuseBleeding: [
                .init(title: AssetString.light.text, type: .red),
                .init(title: AssetString.medium.text, type: .red),
                .init(title: AssetString.strong.text, type: .red),
                .init(title: AssetString.blood_clots.text, type: .red),
            ])
    ]
}
