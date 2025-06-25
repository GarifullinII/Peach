//
//  OnboardingViewModel.swift
//  Peach
//
//  Created by Василий on 13.09.2023.
//

import Foundation
import Combine

protocol OnboardingViewModel: AnyObject {
    var input: PassthroughSubject<OnboardingEvent, Never> { get }
    var output: PassthroughSubject<OnboardingOutput, Never> { get }
}

final class OnboardingViewModelImpl: BaseViewModel, OnboardingViewModel {

    // MARK: - Properties

    var input = PassthroughSubject<OnboardingEvent, Never>()
    var output = PassthroughSubject<OnboardingOutput, Never>()
    var onboadings = CurrentValueSubject<[OnboardingCellModel], Never>([])

    // MARK: - Initializers

    override init() {
        super.init()

        bind()

        onboadings.value = OnboardingCellModel.onboarding
    }

    deinit {
        print("❌Deinit:", String(describing: self))
    }

    // MARK: - Instance methods

    func bind() {
        input.sink { [weak self] event in
            guard let self else { return }

            switch event {
            case .signIn:
                self.output.send(.showSignIn)
            }
        }.store(in: &cancellables)
    }
}
