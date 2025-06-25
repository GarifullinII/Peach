//
//  PremiumViewModel.swift
//  Peach
//
//  Created by Василий on 11.09.2023.
//

import UIKit
import Combine

protocol PremiumViewModel: AnyObject {
    var input: PassthroughSubject<PremiumInput, Never> { get }
    var output: PassthroughSubject<PremiumOutput, Never> { get }
}

final class PremiumViewModelImpl: BaseViewModel, PremiumViewModel {

    // MARK: - Properties

    var input = PassthroughSubject<PremiumInput, Never>()
    var output = PassthroughSubject<PremiumOutput, Never>()

    var paymentCellModel = CurrentValueSubject<[PaymentCellModel], Never>([])
    var cells = CurrentValueSubject<[PaymentCell], Never>([])
    var paymentID = CurrentValueSubject<Int?, Never>(nil)
    var presentationType = CurrentValueSubject<PresentationType?, Never>(nil)

    // MARK: - Initializers

    init(presentation: PresentationType) {
        super.init()

        paymentCellModel.value = PaymentCellModel.payments
        presentationType.value = presentation
        
        bind()
    }

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    private func bind() {
        input.sink { [weak self] event in
            switch event {
            case .paymentTap:
                self?.output.send(.showPayment(self?.paymentID.value ?? 0))
            case .dismiss:
                self?.output.send(.dismsiss)
            }
        }.store(in: &cancellables)
    }
}
