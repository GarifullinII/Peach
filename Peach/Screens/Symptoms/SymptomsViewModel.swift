//
//  SymptomsViewModel.swift
//  Peach
//
//  Created by Василий on 22.09.2023.
//

import Combine
import UIKit

protocol SymptomsViewModel: AnyObject {
    var input: PassthroughSubject<SymptomsInput, Never> { get }
    var output: PassthroughSubject<SymptomsOutput, Never> { get }
}

final class SymptomsViewModelImpl: BaseViewModel, SymptomsViewModel {

    // MARK: - Properties

    var input = PassthroughSubject<SymptomsInput, Never>()
    var output = PassthroughSubject<SymptomsOutput, Never>()

    var dataSource = CurrentValueSubject<BaseSymptomsModel?, Never>(nil)
    var headerDataSource = CurrentValueSubject<[String], Never>([])

    var selectedSymptoms: [IndexPath: Bool] = [:]
    var additionalSymptom: String = ""

    var retrieveSymptomModel: Symptoms?

    private let currentDate: Date

    // MARK: - Initializers

    init(date: Date) {
        self.currentDate = date

        super.init()

        bind()
        setup()
        load(date: date)
    }

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    private func setup() {
        dataSource.value = BaseSymptomsModel.model.first
        headerDataSource.value = [
            AssetString.symptoms.text,
            AssetString.discharge.text,
            AssetString.profuse_bleeding.text
        ]
    }

    private func bind() {
        input.sink { [weak self] input in
            guard let self else { return }

            switch input {
            case .refreshModel(let indexPath):
                if selectedSymptoms.contains(where: {$0.key == indexPath} ) {
                    selectedSymptoms[indexPath] = nil
                } else {
                    selectedSymptoms[indexPath] = true
                }
            case .addAdditionalSymptom(let additionalSymptom):
                self.additionalSymptom = additionalSymptom
            case .save:
                self.save()
            case .dismiss:
                self.output.send(.dismiss)
            }
        }.store(in: &cancellables)
    }

    private func save() {
        if !SymptomsManager.shared.contains(date: currentDate) && (!additionalSymptom.isEmpty || !selectedSymptoms.isEmpty)  {
            // save
            let symptomsModel = Symptoms(
                date: currentDate,
                symptoms: Array(selectedSymptoms.keys),
                note: additionalSymptom
            )

            SymptomsManager.shared.add(model: symptomsModel)
        } else if SymptomsManager.shared.contains(date: currentDate) && (!additionalSymptom.isEmpty || !selectedSymptoms.isEmpty)  {
            // update
            SymptomsManager.shared.update(
                date: currentDate,
                symptoms: Array(selectedSymptoms.keys),
                note: additionalSymptom
            )
        } else {
            // delete
            SymptomsManager.shared.remove(date: currentDate)
        }

        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(.success)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.input.send(.dismiss)
        }
    }

    func load(date: Date) {
        let model = SymptomsManager.shared.get(date: date)
        retrieveSymptomModel = model

        additionalSymptom = model?.note ?? ""
        model?.symptoms.forEach{  indexPath in
            selectedSymptoms[indexPath] = true
        }
    }
}
